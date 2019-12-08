class RemoveMagicItemGainedAndLost < ActiveRecord::Migration[5.2]
  def change
    remove_column :adventure_logs, :magic_items_gained
    remove_column :adventure_logs, :magic_items_lost
  end
end
