class MagicItem < ActiveRecord::Base
  belongs_to :character, foreign_key: "character_id"
end
