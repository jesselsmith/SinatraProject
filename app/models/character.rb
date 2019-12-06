class Character < ActiveRecord::Base
  has_many :adventure_logs, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  extend Concerns::Slugifiable::ClassMethods
  include Concerns::Slugifiable::InstanceMethods

  def gold
    self.starting_gold + self.adventure_logs.sum{|log| log.gold_change} 
  end

  def downtime
    self.starting_downtime + self.adventure_logs.sum{|log| log.downtime_change}
  end

  def level
    self.starting_level + self.adventure_logs.sum{|log| log.level_up ? 1 : 0 }
  end
end
