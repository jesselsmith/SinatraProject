class AddClassToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :class, :string
  end
end
