class ChangeLevelGoldDowntimeToStartingLevelGoldDowntime < ActiveRecord::Migration[5.2]
  def change
    rename_column :characters, :level, :starting_level
    rename_column :characters, :gold, :starting_gold
    rename_column :characters, :downtime, :starting_downtime
  end
end
