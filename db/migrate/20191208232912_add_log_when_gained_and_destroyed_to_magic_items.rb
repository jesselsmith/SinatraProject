class AddLogWhenGainedAndDestroyedToMagicItems < ActiveRecord::Migration[5.2]
  def change
    add_column :magic_items, :adventure_log_gained_id, :integer
    add_column :magic_items, :adventure_log_lost_id, :integer
  end
end
