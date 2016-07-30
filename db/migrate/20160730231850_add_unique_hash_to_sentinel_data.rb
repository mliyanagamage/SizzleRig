class AddUniqueHashToSentinelData < ActiveRecord::Migration[5.0]
  def change
    add_column :sentinel_data, :unique_hash, :string
  end
end
