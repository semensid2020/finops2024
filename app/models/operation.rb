# == Schema Information
#
# Table name: operations
#
#  id            :bigint           not null, primary key
#  amount        :decimal(10, 2)   not null
#  deleted_at    :datetime
#  planned_at    :datetime
#  state         :integer          default("pending"), not null
#  temporal_type :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  currency_id   :bigint           not null
#  recipient_id  :bigint           not null
#  sender_id     :bigint           not null
#
# Indexes
#
#  index_operations_on_currency_id   (currency_id)
#  index_operations_on_deleted_at    (deleted_at)
#  index_operations_on_planned_at    (planned_at)
#  index_operations_on_recipient_id  (recipient_id)
#  index_operations_on_sender_id     (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (currency_id => currencies.id)
#  fk_rails_...  (recipient_id => user_accounts.id)
#  fk_rails_...  (sender_id => user_accounts.id)
#
class Operation < ApplicationRecord
  acts_as_paranoid
  include BusinessRules::Operation

  belongs_to :sender, class_name: 'UserAccount', inverse_of: :sender_operations
  belongs_to :recipient, class_name: 'UserAccount', inverse_of: :recipient_operations
  belongs_to :currency

  validates :sender_id, presence: true
  validates :recipient_id, presence: true
  validates :sender_id, comparison: { other_than: :recipient_id }

  validates :currency_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :state, presence: true
  validates :temporal_type, presence: true
  validates :planned_at, presence: true, if: :scheduled_type?
  validates :planned_at, absence: true, if: :immediate_type?

  enum :temporal_type, { immediate: 0, scheduled: 1 }, suffix: :type
  enum :state, { pending: 0, done: 1, declined: 2, cancelled: 3, failured: 4 }, suffix: :state

  scope :active, -> { where(deleted_at: nil) }
end
