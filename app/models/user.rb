class User < ActiveRecord::Base
  has_secure_password

  has_many :characters, dependent: :destroy
  has_many :logs, through: :characters, dependent: :destroy

  extend Concerns::Slugifiable::ClassMethods
  include Concerns::Slugifiable::InstanceMethods
end
