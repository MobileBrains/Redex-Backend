class AddImageToDevolutions < ActiveRecord::Migration[5.0]
  def change
    add_column :devolutions, :image, :string
  end
end
