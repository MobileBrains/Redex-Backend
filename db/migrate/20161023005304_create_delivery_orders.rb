class CreateDeliveryOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :delivery_orders do |t|
      t.date :radication_at
      t.date :delivered_at
      t.integer :charge_number
      t.string :delivery_man
      t.string :city
      t.string :internal_guide
      t.string :destinatary
      t.string :adderss
      t.string :client
      t.string :externa_guide
      t.integer :state
      t.string :image

      t.timestamps
    end
  end
end
