class AddImageToCourriersLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :courriers_locations, :image, :string
  end
end
