class AddMailDeliveryOfficeIdToDeliveryOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :delivery_orders, :mail_delivery_office_id, :integer
  end
end
