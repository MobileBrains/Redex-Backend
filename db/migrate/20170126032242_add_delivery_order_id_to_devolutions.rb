class AddDeliveryOrderIdToDevolutions < ActiveRecord::Migration[5.0]
  def change
    add_column :devolutions, :delivery_order_id, :integer
    add_index :devolutions, :delivery_order_id
  end
end
