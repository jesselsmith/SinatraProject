class Character < ActiveRecord::Base
  has_many :adventure_logs, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  extend Concerns::Slugifiable::ClassMethods
  include Concerns::Slugifiable::InstanceMethods
end
