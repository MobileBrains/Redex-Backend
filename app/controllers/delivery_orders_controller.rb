class DeliveryOrdersController < ApplicationController

  def index
    @delivery_orders = DeliveryOrder.all
  end

  def import
    begin
      DeliveryOrder.import(params[:file])
      redirect_to delivery_orders_path, notice: "Entregas importadas correctamente."
    rescue => e
      puts "DeliveryOrdersController.import => exception: #{e}"
      redirect_to delivery_orders_path, alert: "Archivo CSV con formato invalido."
    end
  end

  def excelImport
    begin
      DeliveryOrderImporter.import(params[:excelFile])
      redirect_to delivery_orders_path, notice: "Entregas importadas correctamente."
    rescue => e
      puts "DeliveryOrdersController.excelImport => exception: #{e}"
      redirect_to delivery_orders_path, alert: "No ha seleccionado archivo o archivo con formato invalido."
    end
  end


end
