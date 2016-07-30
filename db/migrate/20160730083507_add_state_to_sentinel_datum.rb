class AddStateToSentinelDatum < ActiveRecord::Migration[5.0]
  def change
    add_column :sentinel_data, :australian_state, :string
  end
end
