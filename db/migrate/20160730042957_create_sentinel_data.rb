class CreateSentinelData < ActiveRecord::Migration[5.0]
  def change
    create_table :sentinel_data do |t|

      t.timestamps
    end
  end
end
