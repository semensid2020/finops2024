class OperationExecutionService < ApplicationService
  attr_reader :operation

  class OperationPreconditionsError < StandardError; end

  # Retry count for deadlock errors
  MAX_RETRIES = 3

  def initialize(operation)
    @operation = operation
  end

  def call
    # rubocop:disable Rails/SkipsModelValidations
    retries = 0
    begin
      # Start a database transaction
      ActiveRecord::Base.transaction do
        Rails.logger.info "Attempting transaction: #{operation.temporal_type} operation (id #{operation.id})\n
                            from sender (id #{operation.sender.id})to recipient (id #{operation.recipient.id}) at #{Time.now.utc}}"

        # Lock sender and recipient accounts for update (pessimistic locking)
        sender = UserAccount.lock.find(operation.sender_id)
        recipient = UserAccount.lock.find(operation.recipient_id)

        # Raise error if preconditions fail
        raise OperationPreconditionsError, 'Sender does not have sufficient balance' unless sender.balance >= operation.amount
        raise OperationPreconditionsError, 'Sender account has wrong status' unless sender.active?
        raise OperationPreconditionsError, 'Recipient account has wrong status' unless recipient.active?

        # Withdraw money from sender and deposit it to recipient
        sender.withdraw_money(operation.amount)
        recipient.deposit_money(operation.amount)
        sleep 60 if operation.temporal_type == 'scheduled'
        sleep 120 if operation.temporal_type == 'immediate'

        # Save the sender and recipient accounts
        sender.save!
        recipient.save!

        # Update operation state to done
        operation.update_attribute(:state, :done)
      end
    rescue ActiveRecord::StatementInvalid => e
      # Catch database-specific errors (like deadlock errors)
      if retries < MAX_RETRIES && e.message.include?('deadlock')
        retries += 1
        Rails.logger.warn "Deadlock detected, retrying operation (id #{operation.id})... Retry #{retries}/#{MAX_RETRIES}"
        retry
      else
        # Handle other SQL errors
        Rails.logger.error "Unexpected database error during operation #{operation.id}: #{e.message}"
        operation.update_attribute(:state, :failured)
      end
    # Проверяем валидации (чего?) пока не знаю как это сэмулировать
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Operation #{operation.id} declined due to some validation error: #{e.message}"
      operation.update_attribute(:state, :declined)
    rescue OperationPreconditionsError => e
      Rails.logger.error "Operation #{operation.id} declined due to: #{e.message}"
      operation.update_attribute(:state, :declined)
    # Catch all other unexpected errors
    rescue StandardError => e
      Rails.logger.error "Unexpected error during operation #{operation.id}: #{e.message}"
      operation.update_attribute(:state, :failured)
    ensure
      Rails.logger.info "Finishing transaction: #{operation.id} from #{operation.sender.id} to #{operation.recipient.id} with state #{operation.state}"
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
end
