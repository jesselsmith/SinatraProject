class AddClassToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :character_class, :string
  end
end
