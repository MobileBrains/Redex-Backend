# == Schema Information
#
# Table name: delivery_orders
#
#  id             :integer          not null, primary key
#  radication_at  :datetime
#  delivered_at   :datetime
#  charge_number  :integer
#  delivery_man   :string
#  city           :string
#  internal_guide :string
#  destinatary    :string
#  adderss        :string
#  client         :string
#  externa_guide  :string
#  state          :integer          default("pendiente")
#  image          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class DeliveryOrder < ApplicationRecord
  require 'csv'
  has_many :devolution

  enum state: { pendiente: 0,
                entregada: 1,
                devolucion: 2
              }



  def self.import(file)
    begin
      csv_header = [
        :radication_at,
        :charge_number,
        :delivery_man,
        :city,
        :internal_guide,
        :destinatary,
        :adderss,
        :client,
        :externa_guide
      ]

      CSV.foreach(file.path, {:headers => true, skip_lines: /;;;/, col_sep: ';', encoding: Encoding::ISO_8859_1}) do |row|
        delivery_order = DeliveryOrder.where(internal_guide: row[4])
        delivery_order_params = [csv_header,row[0..(row.size-2)]].transpose
        delivery_order_hash = Hash[*delivery_order_params.flatten(1)]
        if delivery_order.count == 1
          delivery_order.first.update_attributes(delivery_order_hash)
        else
          DeliveryOrder.create!(delivery_order_hash)
        end
      end
    rescue => e
      puts "exception model: #{e}"
    end
  end
end
