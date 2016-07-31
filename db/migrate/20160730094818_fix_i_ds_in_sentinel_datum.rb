class FixIDsInSentinelDatum < ActiveRecord::Migration[5.0]
  def change
    add_column :sentinel_data, :hotspot_id, :string
    remove_column :sentinel_data, :sentinel_id
    add_column :sentinel_data, :sentinel_id, :integer
  end
end
