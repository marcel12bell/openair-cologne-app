class CreateSensors < ActiveRecord::Migration[5.0]
  def change
    create_table :sensors do |t|
      t.string :node_id
      t.string :name
      t.string :mqtt_id
      t.string :mqtt_pass
      t.integer :user_id
    end
    add_index :sensors, [:node_id], unique: true
  end
end
