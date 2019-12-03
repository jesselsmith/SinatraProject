class AdventureLog < ActiveRecord::Base
  belongs_to :character, foreign_key: "character_id"
  has_one :user, through: :character
end
