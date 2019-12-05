class AddLevelUpToAdventureLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :adventure_logs, :level_up, :boolean
  end
end
