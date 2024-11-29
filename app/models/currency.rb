# == Schema Information
#
# Table name: currencies
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  deleted_at :datetime
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_currencies_on_code        (code) UNIQUE
#  index_currencies_on_deleted_at  (deleted_at)
#  index_currencies_on_name        (name) UNIQUE
#
class Currency < ApplicationRecord
  acts_as_paranoid

  has_many :user_accounts
  has_many :operations

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  scope :active, -> { where(deleted_at: nil) }
end
