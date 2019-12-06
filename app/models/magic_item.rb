class MagicItem < ActiveRecord::Base
  belongs_to :character, foreign_key: "character_id"

  def self.new_from_string(string)
    string.split("\n").map do |substring|
      self.new(name: substring.strip)
    end
  end

  def self.new_from_adventure_log(adventure_log)
    new_items = self.new_from_string(adventure_log.magic_items_gained)
    adventure_log.character.magic_items << new_items
  end
end
