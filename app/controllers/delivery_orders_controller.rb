class DeliveryOrdersController < ApplicationController
  def index
    @delivery_orders = DeliveryOrder.all
  end

  def import
    begin
      DeliveryOrder.import(params[:file])
      redirect_to delivery_orders_path, notice: "Entregas importadas correctamente."
    rescue => e
      puts "exception: #{e}"
      redirect_to delivery_orders_path, notice: "Archivo CSV con formato invalido."
    end
  end


end
