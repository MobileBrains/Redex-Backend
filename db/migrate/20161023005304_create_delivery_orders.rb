class CreateDeliveryOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :delivery_orders do |t|
      t.datetime :radication_at
      t.datetime :delivered_at
      t.integer :charge_number
      t.string :delivery_man
      t.string :city
      t.string :internal_guide
      t.string :destinatary
      t.string :adderss
      t.string :client
      t.string :externa_guide
      t.integer :state, default: 0
      t.string :image

      t.timestamps
    end
  end
end
