class CurrenciesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_currency!, only: %i[show destroy edit update]

  def index
    @currencies = Currency.all
  end

  def show; end

  def new
    @currency = Currency.new
  end

  def edit; end

  def create
    @currency = Currency.new(currency_params)
    if @currency.save
      flash.now[:success] = 'Currency successfully created'

      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'shared/flash'),
        turbo_stream.update('form-errors', '')
      ]
    else
      flash.now[:alert] = 'Failed to create a new currency.'

      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'shared/flash'),
        turbo_stream.update('form-errors', partial: 'shared/errors', locals: { object: @currency })
      ], status: :unprocessable_entity
    end
  end

  def update
    if @currency.update(currency_params)
      flash.now[:success] = 'Currency successfully updated'

      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'shared/flash'),
        turbo_stream.update('form-errors', '')
      ]
    else
      flash.now[:alert] = 'Failed to update the currency.'

      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'shared/flash'),
        turbo_stream.update('form-errors', partial: 'shared/errors', locals: { object: @currency })
      ], status: :unprocessable_entity
    end
  end

  def destroy
    @currency = Currency.find(params[:id])
    @currency.destroy

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = 'Currency successfully deleted.'
        render turbo_stream: [
          turbo_stream.remove("currency_#{@currency.id}"),
          turbo_stream.update('flash-messages', partial: 'shared/flash')
        ]
      end
    end
  end

  private

  def set_currency!
    @currency = Currency.find(params[:id])
  end

  def currency_params
    params.require(:currency).permit(:name, :code)
  end
end
