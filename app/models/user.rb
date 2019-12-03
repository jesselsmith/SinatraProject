class User < ActiveRecord::Base
  has_secure_password

  has_many :characters, dependent: :destroy
  has_many :adventure_logs, through: :characters, dependent: :destroy

  extend Concerns::Slugifiable::ClassMethods
  include Concerns::Slugifiable::InstanceMethods
end
