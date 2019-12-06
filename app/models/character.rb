class Character < ActiveRecord::Base
  has_many :adventure_logs, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  extend Concerns::Slugifiable::ClassMethods
  include Concerns::Slugifiable::InstanceMethods

  def gold
    self.starting_gold + self.adventure_logs.sum(&:gold_change)
  end

  def downtime
    self.starting_downtime + self.adventure_logs.sum(&:downtime_change)
  end

  def level
    current_level = self.starting_level +
                    self.adventure_logs.sum { |log| log.level_up ? 1 : 0 }

    current_level = 20 if current_level > 20
    current_level
  end
end
