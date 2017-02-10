class HomeController < ApplicationController
  def hello
  end

  def info
    @courrier_users = User.with_role(:Courrier)
    @pending_orders = DeliveryOrder.where(state: 'pendiente')
    @delivered_orders = DeliveryOrder.where(state: 'entregada')
    @devolutions = DeliveryOrder.where(state: 'devolucion')
    @devolutionsReg = Devolution.all
  end

  def ordersByCourrierName
      courrierName = params[:name]
      @pending_orders = DeliveryOrder.where(delivery_man: courrierName, state: "pendiente")
      @delivered_orders = DeliveryOrder.where(delivery_man: courrierName, state: "entregada")
      @devolutions = DeliveryOrder.where(delivery_man: courrierName, state: "devolucion")

      respond_to do |response|
        response.json { render json: @pending_orders + @delivered_orders + @devolutions}

        #delivered.json { render json: @delivered_orders }
        #devolution.json { render json: @devolutions }
      end
  end

  def ordersByChargeNumber
      charge_number = params[:charge_number]
      @pending_orders = DeliveryOrder.where(charge_number: charge_number, state: "pendiente")
      @delivered_orders = DeliveryOrder.where(charge_number: charge_number, state: "entregada")
      @devolutions = DeliveryOrder.where(charge_number: charge_number, state: "devolucion")

      respond_to do |response|
        response.json { render json: @pending_orders + @delivered_orders + @devolutions}

        #delivered.json { render json: @delivered_orders }
        #devolution.json { render json: @devolutions }
      end
  end

  def devolutionsPage

      @devolutions = Devolution.all

  end



  def devolutionReasonAndObservation
      @dataResponse = Devolution.where(delivery_order_id: params[:delivery_order_id]).pluck(:devolution_reason, :observation)
      respond_to do |response|
        response.json { render json: @dataResponse}
      end
  end

end
