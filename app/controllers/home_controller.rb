class HomeController < ApplicationController
  def hello
  end

  def info
    office_id = current_user.mail_delivery_office_id
    @courrier_users = User.with_role(:Courrier).where(mail_delivery_office_id: office_id)
    @pending_orders = DeliveryOrder.where(state: 'pendiente').where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day)
    @delivered_orders = DeliveryOrder.where(state: 'entregada').where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day)
    @devolutions = DeliveryOrder.where(state: 'devolucion').where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day)
    @devolutionsReg = Devolution.all.where(mail_delivery_office_id: office_id)
  end

  def infoBetweenDates
    office_id = current_user.mail_delivery_office_id
    courrierName = params[:user_name]


    @orders = DeliveryOrder.where(:created_at => params[:date1].to_time.strftime("%m/%d/%Y").beginning_of_day..params[:date2].to_time.strftime("%m/%d/%Y").end_of_day)
    #@pending_orders = DeliveryOrder.where(state: 'pendiente').where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day)
    #@delivered_orders = DeliveryOrder.where(state: 'entregada').where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day)
    #@devolutions = DeliveryOrder.where(state: 'devolucion').where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day)
    #@devolutionsReg = Devolution.all.where(mail_delivery_office_id: office_id)

    respond_to do |response|
        response.json { render json: @orders }
        #response.json { render json: @pending_orders + @delivered_orders + @devolutions}

        #delivered.json { render json: @delivered_orders }
        #devolution.json { render json: @devolutions }
      end

  end

  def ordersByCourrierName
      office_id = current_user.mail_delivery_office_id
      courrierName = params[:name]
      @pending_orders = DeliveryOrder.where(delivery_man: courrierName, state: "pendiente").where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day)
      @delivered_orders = DeliveryOrder.where(delivery_man: courrierName, state: "entregada").where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day)
      @devolutions = DeliveryOrder.where(delivery_man: courrierName, state: "devolucion").where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day)

      respond_to do |response|
        response.json { render json: @pending_orders + @delivered_orders + @devolutions}

        #delivered.json { render json: @delivered_orders }
        #devolution.json { render json: @devolutions }
      end
  end

  def ordersByChargeNumber
      office_id = current_user.mail_delivery_office_id
      charge_number = params[:charge_number]
      @pending_orders = DeliveryOrder.where(charge_number: charge_number, state: "pendiente").where(mail_delivery_office_id: office_id)
      @delivered_orders = DeliveryOrder.where(charge_number: charge_number, state: "entregada").where(mail_delivery_office_id: office_id)
      @devolutions = DeliveryOrder.where(charge_number: charge_number, state: "devolucion").where(mail_delivery_office_id: office_id)

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

  def courriersLocations
    @courriersLocations = CourriersLocation.all.last(100)
  end

end
