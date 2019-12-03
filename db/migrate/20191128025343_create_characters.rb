class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :level
      t.integer :gold
      t.integer :downtime
      t.string :faction
      t.boolean :adventurers_league
      t.bigint :user_id
    
      t.timestamps
    end
    
  end
end
