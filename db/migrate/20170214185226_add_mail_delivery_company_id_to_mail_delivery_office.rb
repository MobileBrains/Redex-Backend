class AddMailDeliveryCompanyIdToMailDeliveryOffice < ActiveRecord::Migration[5.0]
  def change
    add_column :mail_delivery_offices, :mail_delivery_company_id, :integer
  end
end
