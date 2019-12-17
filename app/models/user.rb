class User < ActiveRecord::Base
  has_secure_password

  has_many :characters, dependent: :destroy
  has_many :adventure_logs, through: :characters, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :password_digest, presence: true
  

  extend Concerns::Slugifiable::ClassMethods
  include Concerns::Slugifiable::InstanceMethods
end
