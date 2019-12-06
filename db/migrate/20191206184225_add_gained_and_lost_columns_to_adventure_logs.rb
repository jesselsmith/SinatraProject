class AddGainedAndLostColumnsToAdventureLogs < ActiveRecord::Migration[5.2]
  def change
    rename_column :adventure_logs, :gold_change, :gold_gained
    rename_column :adventure_logs, :downtime_change, :downtime_gained
    add_column :adventure_logs, :gold_lost, :integer, default: 0
    add_column :adventure_logs, :downtime_lost, :integer, default: 0
  end
end
