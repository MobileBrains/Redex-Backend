class CreateMailDeliveryOffices < ActiveRecord::Migration[5.0]
  def change
    create_table :mail_delivery_offices do |t|
      t.string :name
      t.string :address
      t.string :email
      t.integer :phone
      t.float :latitude
      t.float :longitude
      t.integer :user_id
      t.string :image

      t.timestamps
    end
  end
end
