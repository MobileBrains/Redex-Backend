class DeliveryOrderImporter < ActiveImporter::Base
  imports DeliveryOrder

  skip_rows_if { row['GUIA_INTERNA'].blank? }

  column 'FECHA', :radication_at
  column 'N°_CARGUE', :charge_number
  column 'MENSAJERO', :delivery_man
  column 'CIUDAD', :city
  column 'GUIA_INTERNA', :internal_guide
  column 'DESTINATARIO', :destinatary
  column 'DIRECCION', :address
  column 'CLIENTE', :client
  column 'GUIA_EXTERNA', :externa_guide

  on :import_failed do |ex|
    Rails.logger.error("Could not start importing data: #{ex}")
  end

end