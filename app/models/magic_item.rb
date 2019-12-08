class MagicItem < ActiveRecord::Base
  belongs_to :character, foreign_key: "character_id"

  def self.new_from_string(string)
    string.split("\n").map do |substring|
      self.new(name: substring.strip) unless substring.strip.empty?
    end
  end

  def self.new_from_adventure_log(adventure_log)
    new_items = self.new_from_string(adventure_log.magic_items_gained)
    adventure_log.character.magic_items << new_items
  end

  def adventure_log_gained
    AdventureLog.find(adventure_log_gained_id)
  end

  def adventure_log_gained=(adventure_log_id)
    self.sadventure_log_gained_id = adventure_log_id
  end


  def adventure_log_lost
    AdventureLog.find(adventure_log_gained_id)
  end

  def adventure_log_lost=(adventure_log_id)
    self.adventure_log_gained_id = adventure_log_id
  end
end
