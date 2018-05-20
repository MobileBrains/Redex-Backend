class CreateManagementReports < ActiveRecord::Migration[5.0]
  def change
    create_table :management_reports do |t|
      t.string :name
      t.string :link
      t.string :description
      t.integer :user_id
      t.integer :client_id

      t.timestamps
    end
  end
end
