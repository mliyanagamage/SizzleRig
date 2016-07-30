class CreateSentinelData < ActiveRecord::Migration[5.0]
  def change
    create_table :sentinel_data do |t|
      t.decimal :latitude, :precision => 10, :scale => 7
      t.decimal :longitude, :precision => 10, :scale => 7
      t.decimal :temp_k, :precision => 4, :scale => 1
      t.decimal :sh, :precision => 4, :scale => 3
      t.decimal :sl, :precision => 4, :scale => 3
      t.integer :confidence
      t.datetime :datetime
      t.string :offset
      t.timestamps
    end
  end
end
