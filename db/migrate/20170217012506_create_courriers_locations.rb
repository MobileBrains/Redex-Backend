class CreateCourriersLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :courriers_locations do |t|
      t.float :latitude
      t.float :longitude
      t.integer :user_id
      t.integer :location_type

      t.timestamps
    end
  end
end
