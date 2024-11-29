class UserAccountsController < ApplicationController
  before_action :authenticate_user!
  # before_action :authorize_user_account_ownership!, only: %i[edit update destroy]
  before_action :set_user_account!, only: %i[show destroy edit update]

  def index
    @user_accounts = UserAccount.includes([:currency])
                                .includes([:owner])
                                .decorate&.order(id: :desc)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def authorize_user_account_ownership!
    return if current_user.admin_role?
    return if UserAccount.find(params[:id]).owner == current_user

    render(:file => Rails.public_path.join('403.html').to_s, :status => :forbidden, :layout => false)
  end

  def set_user_account!
    @user_account = UserAccount.find(params[:id]).decorate
  end

  def user_account_params
    # params.require(:operation).permit(:content, :landing_form_id, product_ids: [])
  end
end
