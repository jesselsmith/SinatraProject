class Character < ActiveRecord::Base
  has_many :adventure_logs
  belongs_to :user, foreign_key: "user_id"
end
