class CreateAdventureLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :adventure_logs do |t|
      t.string :adventure_name
      t.string :dm_name
      t.string :dm_dci
      t.integer :gold_change
      t.integer :downtime_change
      t.string :notes
      t.bigint :character_id
      t.timestamps
    end
    
  end
end
