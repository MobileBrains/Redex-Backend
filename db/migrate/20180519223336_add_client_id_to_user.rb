class AddClientIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :client_id, :integer
  end
end
