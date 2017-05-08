class DeliveryOrdersController < ApplicationController

  def index
    @delivery_orders = DeliveryOrder.all
  end

  def import
    begin
      DeliveryOrderImportWorker.perform_async(params[:file].tempfile.path)
      redirect_to delivery_orders_path, notice: "Las entregas estan siendo procesadas."
    rescue => e
      puts "DeliveryOrdersController.import => exception: #{e}"
      redirect_to delivery_orders_path, alert: "Archivo CSV con formato invalido."
    end
  end

  def excelImport
    begin
      mail_delivery_office_id = current_user.mail_delivery_office_id
      uploaded_by = current_user.id

      DeliveryOrderExcelImportWorker.perform_async(params[:excelFile].tempfile.path, mail_delivery_office_id, uploaded_by)
      redirect_to delivery_orders_path, notice: "Las entregas estan siendo procesadas."
    rescue => e
      puts "DeliveryOrdersController.excelImport => exception: #{e}"
      redirect_to delivery_orders_path, alert: "No ha seleccionado archivo o archivo con formato invalido."
    end
  end


end
