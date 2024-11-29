class OperationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_operation_availability!, only: :show
  before_action :authorize_operation_authorship!, only: %i[edit update cancel]
  before_action :set_operation!, only: %i[show edit update]

  def index
    if current_user.admin_role?
      @operations = load_operations.decorate&.order(id: :desc)
    else
      my_operations_ids = []
      my_sender_operations_ids = Operation.includes([:sender]).where(sender: { owner_id: current_user.id }).pluck(:id)
      my_sender_recipient_ids = Operation.includes([:recipient]).where(recipient: { owner_id: current_user.id }).pluck(:id)
      my_operations_ids = my_sender_operations_ids + my_sender_recipient_ids

      @operations = load_operations.where(id: my_operations_ids).decorate&.order(id: :desc)
    end

    @operations
  end

  def show; end

  def new
    @currencies = Currency.all
    @user_accounts = UserAccount.all
    @operation = Operation.new
  end

  def edit; end

  def create
    # Set the user's time zone
    Time.zone = params[:operation][:time_zone]
    operation_time = Time.zone.parse(params[:operation][:planned_at])
    fixed_operation_params = operation_params
    fixed_operation_params[:planned_at] = operation_time
    @operation = Operation.new(fixed_operation_params)
    if @operation.save
      flash.now[:success] = 'Financial operation successfully created/scheduled'

      ops_delay = @operation.planned_at.present? ? (@operation.planned_at - Time.zone.now) : 5.seconds
      OperationExecutionJob.set(wait: ops_delay).perform_later(@operation)
      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'shared/flash'),
        turbo_stream.update('form-errors', '')
      ]
    else
      flash.now[:alert] = 'Failed to create a new financial operation.'

      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'shared/flash'),
        turbo_stream.update('form-errors', partial: 'shared/errors', locals: { object: @operation })
      ], status: :unprocessable_entity
    end
  end

  def update
  end

  def cancel
  end

  private

  def load_operations
    Operation.includes([:sender, { sender: [:owner] }])
             .includes([:recipient, { recipient: [:owner] }])
             .includes([:currency])
  end

  def operation_params
    params.require(:operation).permit(:sender_id, :recipient_id, :currency_id, :amount, :temporal_type, :planned_at)
  end

  def set_operation!
    @operation = Operation.find(params[:id]).decorate
  end

  def authorize_operation_availability!
    return if current_user.admin_role?
    return if Operation.find(params[:id]).sender.owner == current_user || Operation.find(params[:id]).recipient.owner == current_user

    render(:file => Rails.public_path.join('403.html').to_s, :status => :forbidden, :layout => false)
  end

  def authorize_operation_authorship!
    return if current_user.admin_role?
    return if Operation.find(params[:id]).sender.owner == current_user

    render(:file => Rails.public_path.join('403.html').to_s, :status => :forbidden, :layout => false)
  end
end
