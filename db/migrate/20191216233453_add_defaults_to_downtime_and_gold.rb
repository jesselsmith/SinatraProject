class AddDefaultsToDowntimeAndGold < ActiveRecord::Migration[5.2]
  def change
    change_column_default :characters, :starting_downtime, 0
    change_column_default :adventure_logs, :gold_gained, 0
    change_column_default :adventure_logs, :gold_gained, 0
  end
end
