class DeliveryOrderExcelImportWorker
  include Sidekiq::Worker

  def perform(excel_file, mail_delivery_office_id, uploaded_by)
    puts "DeliveryOrderExcelImportWorker >> params -> #{excel_file} - #{mail_delivery_office_id} - #{uploaded_by}"
    DeliveryOrderImporter.import(excel_file, params: { mail_delivery_office_id: mail_delivery_office_id, uploaded_by: uploaded_by })
  rescue => e
    puts "DeliveryOrderExcelImportWorker.perform ERROR: #{e}"
  end
end