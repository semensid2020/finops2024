# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # rubocop:disable Rails/RedundantForeignKey, Rails/UniqueValidationWithoutIndex
  has_many :user_accounts, foreign_key: :user_id
  validates :email, uniqueness: { scope: [:deleted_at] }
  # rubocop:enable Rails/RedundantForeignKey, Rails/UniqueValidationWithoutIndex

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  enum :role, { customer: 0, admin: 1 }, suffix: :role

  scope :active, -> { where(deleted_at: nil) }
end
