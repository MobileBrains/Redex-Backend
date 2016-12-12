class HomeController < ApplicationController
  def hello
  end

  def ensayo
    @courrier_users = User.with_role(:courrier)
    @pending_orders = DeliveryOrder.where(state: 'pendiente')
    @delivered_orders = DeliveryOrder.where(state: 'entregada')
    @devolutions = DeliveryOrder.where(state: 'devolucion')
  end

  def ordenes
      nombre = params[:name]
      @pending_orders = DeliveryOrder.where(delivery_man: nombre, state: "pendiente")
      @delivered_orders = DeliveryOrder.where(delivery_man: nombre, state: "entregada")
      @devolutions = DeliveryOrder.where(delivery_man: nombre, state: "devolucion")

      respond_to do |response|
        response.json { render json: @pending_orders + @delivered_orders + @devolutions}

        #delivered.json { render json: @delivered_orders }
        #devolution.json { render json: @devolutions }
      end


  end
end
