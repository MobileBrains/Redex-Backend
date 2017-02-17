class AddUploadedByToDeliveryOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :delivery_orders, :uploaded_by, :integer
  end
end
