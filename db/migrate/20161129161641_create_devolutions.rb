class CreateDevolutions < ActiveRecord::Migration[5.0]
  def change
    create_table :devolutions do |t|
      t.integer :devolution_reason
      t.text    :observation
      t.integer :delivery_order_internal_guide
      t.integer :user_id

      t.timestamps
    end
  end
end
