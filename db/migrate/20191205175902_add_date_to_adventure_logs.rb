class AddDateToAdventureLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :adventure_logs, :date_played, :date
  end
end
