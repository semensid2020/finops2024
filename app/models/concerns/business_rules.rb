module BusinessRules
  module UserAccount
    extend ActiveSupport::Concern

    included do
    end

    def deposit_money(amount)
      self.balance += amount
    end

    def withdraw_money(amount)
      self.balance -= amount
    end
  end

  module Operation
    extend ActiveSupport::Concern

    included do
      validate :validate_currency
      validate :validate_preconditions, if: :immediate_type?
      validate :validate_planned_at, if: :scheduled_type?
    end

    def validate_currency
      errors.add(:sender_id, 'Operation declined: Wrong currency of operation') unless sender_currency_is_correct
      errors.add(:recipient_id, 'Operation declined: Wrong currency of operation') unless recipient_currency_is_correct
    end

    # тут надо быть поаккуратнее с вопросительными знаками, т.к. иногда они не срабатывают в валидациях. Пока без них
    def validate_preconditions
      errors.add(:sender_id, 'Operation declined: insufficient balance') unless sender_has_sufficient_balance
      errors.add(:sender_id, 'Operation declined: sender account has wrong status') unless sender_status_is_active
      errors.add(:recipient_id, 'Operation declined: recipient account has wrong status') unless recipient_status_is_active
    end

    def validate_planned_at
      return unless planned_at && planned_at < Time.zone.now

      errors.add(:planned_at, "must be greater than or equal to #{Time.zone.now}")
    end

    def sender_currency_is_correct
      currency_id == sender.currency_id
    end

    def recipient_currency_is_correct
      currency_id == recipient.currency_id
    end

    def sender_has_sufficient_balance
      sender.balance >= amount
    end

    def sender_status_is_active
      sender.status == 'active'
    end

    def recipient_status_is_active
      recipient.status == 'active'
    end
  end
end
