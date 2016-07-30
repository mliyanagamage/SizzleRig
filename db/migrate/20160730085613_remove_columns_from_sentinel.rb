class RemoveColumnsFromSentinel < ActiveRecord::Migration[5.0]
  def change
    remove_column :sentinel_data, :sh
    remove_column :sentinel_data, :sl
  end
end
