class CreateMagicItemTable < ActiveRecord::Migration[5.2]
  def change
    create_table :magic_items do |t|
      t.string :name
      t.integer :character_id
      t.timestamps
    end

    add_column :adventure_logs, :magic_items_gained, :string
    add_column :adventure_logs, :magic_items_lost, :string
  end
end
