# == Schema Information
#
# Table name: user_accounts
#
#  id          :bigint           not null, primary key
#  balance     :decimal(10, 2)   not null
#  deleted_at  :datetime
#  status      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  currency_id :bigint           not null
#  owner_id    :bigint           not null
#
# Indexes
#
#  index_user_accounts_on_currency_id  (currency_id)
#  index_user_accounts_on_deleted_at   (deleted_at)
#  index_user_accounts_on_owner_id     (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (currency_id => currencies.id)
#
class UserAccount < ApplicationRecord
  acts_as_paranoid
  include BusinessRules::UserAccount

  belongs_to :owner, class_name: 'User'
  belongs_to :currency

  has_many :sender_operations, class_name: 'Operation', inverse_of: :sender
  has_many :recipient_operations, class_name: 'Operation', inverse_of: :recipient

  validates :owner_id, presence: true
  validates :currency_id, presence: true
  validates :status, presence: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum :status, { on_moderation: 0, active: 1, blocked: 2, expired: 3 }

  scope :active, -> { where(deleted_at: nil) }
end
