class User < ActiveRecord::Base
  has_secure_password
  has_many :purchases
  has_many :properties, through: :purchases

  validates :user_name, presence: true
  validates :email, presence: true, uniqueness: true,
              format: {
                       with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
                         }
end
