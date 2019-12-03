class User < ActiveRecord::Base
  has_secure_password

  has_many :characters
  has_many :logs, through: :characters
end
