class AddLatitudeAndLongitudeToDeliveryOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :delivery_orders, :latitude, :float
    add_column :delivery_orders, :longitude, :float
  end
end
