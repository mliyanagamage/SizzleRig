class AddColumnsToSentinelDatum < ActiveRecord::Migration[5.0]
  def change
    remove_column :sentinel_data, :temp_k
    add_column :sentinel_data, :temp_kelvin, :decimal, :precision => 4, :scale => 1
    add_column :sentinel_data, :sentinel_id, :string
  end
end
