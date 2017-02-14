class AddMailDeliveryOfficeIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mail_delivery_office_id, :integer
  end
end
