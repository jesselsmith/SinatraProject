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

  def total_gold_gained
    self.starting_gold + self.adventure_logs.sum(&:gold_gained)
  end

  def total_gold_lost
    self.adventure_logs.sum(&:gold_lost)
  end

  def total_downtime_gained
    self.starting_downtime + self.adventure_logs.sum(&:downtime_gained)
  end

  def total_downtime_lost
    self.adventure_logs.sum(&:downtime_lost)
  end
end
