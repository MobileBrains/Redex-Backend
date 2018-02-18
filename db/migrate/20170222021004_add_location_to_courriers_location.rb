class AddLocationToCourriersLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :courriers_locations, :location, :string
  end
end
