require 'csv'

class DeliveryOrderImportWorker
  include Sidekiq::Worker

  def perform(file)
    puts "DeliveryOrderImportWorker >> file #{file}"
    csv_header = [
      :radication_at,
      :charge_number,
      :delivery_man,
      :city,
      :internal_guide,
      :destinatary,
      :address,
      :client,
      :externa_guide
    ]

    CSV.foreach(file, {:headers => true, skip_lines: /;;;/, col_sep: ';', encoding: Encoding::ISO_8859_1}) do |row|
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
    puts "DeliveryOrderImportWorker.perform ERROR: #{e}"
  end
end