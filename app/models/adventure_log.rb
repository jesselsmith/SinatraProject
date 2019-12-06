class AdventureLog < ActiveRecord::Base
  belongs_to :character, foreign_key: "character_id"
  has_one :user, through: :character

  def downtime_change
    self.downtime_gained - self.downtime_lost
  end

  def gold_change
    self.gold_gained - self.gold_lost
  end
end
