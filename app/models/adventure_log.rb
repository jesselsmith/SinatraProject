class AdventureLog < ActiveRecord::Base
  belongs_to :character, foreign_key: "character_id"
  has_one :user, through: :character

  def downtime_change
    self.downtime_gained - self.downtime_lost
  end

  def gold_change
    self.gold_gained - self.gold_lost
  end

  def level_before
    self.character.level_before(self)
  end

  def level_after
    level_before + (level_up? ? 1 : 0)
  end

  def gold_before
    self.character.gold_before(self)
  end

  def gold_after
    gold_before + gold_change
  end

  def downtime_before
    self.character.downtime_before(self)
  end

  def downtime_after
    downtime_before + downtime_change
  end
end
