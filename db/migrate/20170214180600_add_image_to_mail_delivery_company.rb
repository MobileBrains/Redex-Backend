class AddImageToMailDeliveryCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :mail_delivery_companies, :image, :string
  end
end
