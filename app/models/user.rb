class User < ActiveRecord::Base
  has_secure_password
  has_many :purchases
  has_many :properties, through: :purchases
end
