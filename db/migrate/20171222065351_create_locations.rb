class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.integer :sensor_id
      t.string :street
      t.string :zip
      t.decimal :longitude, :precision => 10, :scale => 4
      t.decimal :latitude,:precision => 10, :scale => 4
      t.string :altitude
      t.boolean :face_street
      t.boolean :quiet_condition
      t.string :direction
      t.timestamps
    end
  end
end
