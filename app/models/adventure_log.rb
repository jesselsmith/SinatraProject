class AdventureLog < ActiveRecord::Base
  belongs_to :character, foreign_key: "character_id"
  has_one :user, through: :character

  after_destroy do |log|
    log.magic_items_gained.each(&:destroy)
    log.magic_items_lost.each do |item|
      item.adventure_log_lost_id = nil
    end
  end

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

  def magic_items_gained
    MagicItem.where(adventure_log_gained_id: self.id)
  end

  def magic_items_gained=(magic_item_array)
    (magic_item_array - magic_items_gained).each do |item|
      item.adventure_log_gained_id = self.id
    end
    (magic_items_gained - magic_item_array).each do |item|
      item.adventure_log_gained_id = nil
    end
  end

  def magic_items_lost
    MagicItem.where(adventure_log_lost_id: self.id)
  end

  def magic_items_lost=(magic_item_array)
    (magic_item_array - magic_items_lost).each do |item|
      item.adventure_log_lost_id = self.id
    end
    (magic_items_lost - magic_item_array).each do |item|
      item.adventure_log_lost_id = nil
    end
  end
end
