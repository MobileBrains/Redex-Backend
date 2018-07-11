class MapsController < ApplicationController

  def deliveryOrders
      @todayChargesNumbersAndDate = []
      @notTodayChargesNumbersAndDate = []
      @items = []

      office_id = current_user.mail_delivery_office_id
      @courriers = User.where(mail_delivery_office_id: office_id).where.not(latitude: nil, longitude:nil ).with_role :Courrier
      @delivery_orders = DeliveryOrder.where.not(latitude: nil, longitude:nil ).where("created_at >= ?", Time.zone.now.beginning_of_day).where(mail_delivery_office_id: office_id)
      @pendentOrders = DeliveryOrder.where.not(latitude: nil, longitude:nil ).where(mail_delivery_office_id: office_id).where(state: "pendiente").where.not("created_at >= ?", Time.zone.now.beginning_of_day)

      @todayChargesNumbers = DeliveryOrder.where(mail_delivery_office_id: office_id).where("created_at >= ?", Time.zone.now.beginning_of_day).select(:charge_number).distinct
      @todayChargesNumbers.each do |tcharge|
        @items = DeliveryOrder.where("created_at >= ?", Time.zone.now.beginning_of_day).where(mail_delivery_office_id: office_id).where(charge_number: tcharge.charge_number).select(:charge_number, :delivery_man).distinct
        @items.each do |item|
          @todayChargesNumbersAndDate << item
        end
      end

      #@notTodayChargesNumbers = DeliveryOrder.where(mail_delivery_office_id: office_id).where.not("created_at >= ?", Time.zone.now.beginning_of_day).select(:charge_number).distinct
      #@notTodayChargesNumbers.each do |charge|
      #  @items = DeliveryOrder.where.not("created_at >= ?", Time.zone.now.beginning_of_day).where(mail_delivery_office_id: office_id).where(charge_number: charge.charge_number).select(:created_at, :charge_number, :delivery_man).distinct
      #  @items.each do |item|
      #    @notTodayChargesNumbersAndDate << item
      #  end
      #end

      @notTodayChargesNumbers = DeliveryOrder.where(mail_delivery_office_id: office_id).where.not("created_at >= ?", Time.zone.now.beginning_of_day).select(:charge_number, :delivery_man).distinct
      puts @notTodayChargesNumbers.to_json
      @notTodayChargesNumbers.each do |charge|
        @items = DeliveryOrder.where.not("created_at >= ?", Time.zone.now.beginning_of_day).where(mail_delivery_office_id: office_id).where(charge_number: charge.charge_number, delivery_man: charge.delivery_man).last
        puts "last #{@items.to_json}"
        #@items.each do |item|
          @notTodayChargesNumbersAndDate << @items
        #end
      end



      @hash = Gmaps4rails.build_markers(@delivery_orders) do |order, marker|
        marker.lat order.latitude
        marker.lng order.longitude

        if order.state == "pendiente"
          marker.picture({
              "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=P|FF0000|fff|",
              "width" => 35,
              "height" => 42
            })
          marker.infowindow "Estado: <label style='color:red'>#{order.state}</label><br>
                            Cargada al mensajero el: #{order.created_at}<br>
                            <hr>
                            Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                            Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                            Destinatario: #{order.destinatary} <br>
                            Direccion: #{order.address} <br>
                            <hr>
                            Mensajero Encargado: #{order.delivery_man} "
        end

        if order.state == "entregada"
          marker.picture({
              "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=E|70cc29|fff|",
              "width" => 35,
              "height" => 42
            })
          marker.infowindow " Estado: <label style='color:#70cc29'>#{order.state}</label><br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "
        end
        if order.state == "devolucion"
          marker.picture({
              "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=D|e3ba0d|fff|",
              "width" => 35,
              "height" => 42
            })
          marker.infowindow " Estado: <label style='color:#e3ba0d'>#{order.state}</label><br>
                              Razon: #{order.devolution.devolution_reason}<br>
                              Observacion: #{order.devolution.observation}<br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "

        end


      end

      @hash2 = Gmaps4rails.build_markers(@pendentOrders) do |order, marker|
        marker.lat order.latitude
        marker.lng order.longitude

        if order.state == "pendiente"
          marker.picture({
              "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=P|000|fff|",
              "width" => 35,
              "height" => 42
            })
          marker.infowindow "Estado: <label style='color:red'>#{order.state}</label><br>
                            Cargada al mensajero el: #{order.created_at}<br>
                            <hr>
                            Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                            Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                            Destinatario: #{order.destinatary} <br>
                            Direccion: #{order.address} <br>
                            <hr>
                            Mensajero Encargado: #{order.delivery_man} "
        end
      end

  end


  def chargesByCourrier
    office_id = current_user.mail_delivery_office_id
    courrierName = params[:courrierName]
    @todayChargesNumbers = DeliveryOrder.where.not(latitude: nil, longitude:nil ).where(delivery_man: courrierName).where("created_at >= ?", Time.zone.now.beginning_of_day).where(mail_delivery_office_id: office_id).select(:charge_number).distinct
    #chargeNumber = DeliveryOrder.where.not(latitude: nil, longitude:nil ).where(delivery_man: courrierName).where("created_at >= ?", Time.zone.now.beginning_of_day).where(mail_delivery_office_id: office_id).select(:charge_number).distinct
    #@chargeDate = DeliveryOrder.where( char)last.created_at

    respond_to do |response|
      response.json { render json: @todayChargesNumbers}
    end
  end

  def courriersLocation
      office_id = current_user.mail_delivery_office_id
      @courriers = User.where(mail_delivery_office_id: office_id).where.not(latitude: nil, longitude:nil ).with_role :Courrier
      #@courriers = User.where.not(latitude: nil, longitude:nil ).with_role :Courrier
      @hash = Gmaps4rails.build_markers(@courriers) do |courrier, marker|
        marker.lat courrier.latitude
        marker.lng courrier.longitude
        marker.picture({
              "url" => "https://cdn0.iconfinder.com/data/icons/global-logistics-1-2/73/12-32.png",
              "width" => 32,
              "height" => 32
            })

        marker.infowindow " nombre: #{courrier.name} <br>
                            Ultima Ubicacion: #{courrier.location}
                            <hr>
                            fecha de ubicacion: #{courrier.updated_at}  "
      end
  end

  def oneCourrierOnly
      courrierName = params[:courrier_name]
      @courrier = User.where(name: courrierName).with_role :Courrier
      @hash = Gmaps4rails.build_markers(@courrier) do |courrier, marker|
          marker.lat courrier.latitude
          marker.lng courrier.longitude
          marker.picture({
                "url" => "https://cdn0.iconfinder.com/data/icons/global-logistics-1-2/73/12-32.png",
                "width" => 32,
                "height" => 32
              })

          marker.infowindow " id: #{courrier.id} <br>
                              nombre: #{courrier.name} <br>
                              Ultima Ubicacion: #{courrier.location}
                              <hr>
                              Fecha de Ubicacion: #{courrier.updated_at}  "
        end
      respond_to do |response|
        response.json { render json: @hash}
      end
  end

  def allCourrierLocations
    courrierName = params[:courrier_name]
    courrier = User.where(name: courrierName).last
    @allCourrierLocations = CourriersLocation.where(user_id: courrier.id).where("created_at >= ?", Time.zone.now.beginning_of_day)

    @hash = Gmaps4rails.build_markers(@allCourrierLocations) do |courrierLocation, marker|
      marker.lat courrierLocation.latitude
      marker.lng courrierLocation.longitude
      if courrierLocation.location_type == "Requested"
        marker.picture({
                "url" => "https://cdn3.iconfinder.com/data/icons/facebook-ui-flat/48/Facebook_UI-31-32.png",
                "width" => 32,
                "height" => 32
              })
        marker.infowindow " Nombre: #{courrier.name} <br>
                            Ultima Ubicacion: #{courrierLocation.location} <br>
                            Tipo: #{courrierLocation.location_type}
                            <hr>
                            Fecha de ubicacion: #{courrierLocation.created_at}"
      end
      if courrierLocation.location_type == "Automatic"
        marker.picture({
                "url" => "https://cdn3.iconfinder.com/data/icons/facebook-ui-flat/48/Facebook_UI-30-32.png",
                "width" => 32,
                "height" => 32
              })
        marker.infowindow " Nombre: #{courrier.name} <br>
                            Ultima Ubicacion: #{courrierLocation.location} <br>
                            Tipo: #{courrierLocation.location_type}
                            <hr>
                            Fecha de ubicacion: #{courrierLocation.created_at}"

      end
    end

    respond_to do |response|
     response.json { render json: @hash }
    end
  end

  def ordersByChargeNumber
    charge_number = params[:chargeNumber]
    office_id = current_user.mail_delivery_office_id
    @orders = DeliveryOrder.where(mail_delivery_office_id: office_id).where(charge_number: charge_number).where.not(latitude: nil, longitude:nil ).where("created_at >= ?", Time.zone.now.beginning_of_day)
    @not_today_pending_orders = DeliveryOrder.where.not("created_at >= ?", Time.zone.now.beginning_of_day).where.not(latitude: nil, longitude:nil ).where(charge_number: charge_number, state: "pendiente").where(mail_delivery_office_id: office_id)
    #@delivered_orders = DeliveryOrder.where(charge_number: charge_number, state: "entregada").where(mail_delivery_office_id: office_id)
    #@devolutions = DeliveryOrder.where(charge_number: charge_number, state: "devolucion").where(mail_delivery_office_id: office_id)

    @hash = Gmaps4rails.build_markers(@orders) do |order, marker|
      marker.lat order.latitude
      marker.lng order.longitude
      if order.state == "pendiente"
        marker.picture({
                "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=P|FF0000|fff|",
                "width" => 35,
                "height" => 42
              })

          marker.infowindow "Estado: <label style='color:red'>#{order.state}</label><br>
                              Cargada al mensajero el: #{order.created_at}
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "
      end
      if order.state == "entregada"
        marker.picture({
                "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=E|70cc29|fff|",
                "width" => 35,
                "height" => 42
              })

          marker.infowindow " Estado: <label style='color:#70cc29'>#{order.state}</label><br>
                              Cargada al mensajero el: #{order.created_at}
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "
      end
      if order.state == "devolucion"
        marker.picture({
                "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=D|e3ba0d|fff|",
                "width" => 35,
                "height" => 42
              })

          marker.infowindow " Estado: <label style='color:#e3ba0d'>#{order.state}</label><br>
                              Cargada al mensajero el: #{order.created_at}
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "
      end
    end

    @hash2 = Gmaps4rails.build_markers(@not_today_pending_orders) do |order, marker|
      marker.lat order.latitude
      marker.lng order.longitude

      if order.state == "pendiente"
        marker.picture({
            "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=P|000|fff|",
            "width" => 35,
            "height" => 42
          })
        marker.infowindow "Estado: <label style='color:red'>#{order.state}</label><br>
                          Cargada al mensajero el: #{order.created_at}<br>
                          <hr>
                          Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                          Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                          Destinatario: #{order.destinatary} <br>
                          Direccion: #{order.address} <br>
                          <hr>
                          Mensajero Encargado: #{order.delivery_man} "
      end
    end

    respond_to do |response|
     response.json { render json: @hash2 + @hash }
    end
  end


  def requestedCourrierRoute

    courrierName = params[:courrier_name]
    courrier = User.where(name: courrierName).last
    @requestedCourrierLocations = CourriersLocation.where(user_id: courrier.id).where(location_type: "Requested").where("created_at >= ?", Time.zone.now.beginning_of_day)
    @hash = Gmaps4rails.build_markers(@requestedCourrierLocations) do |requestedCourrierLocations, marker|
          marker.lat requestedCourrierLocations.latitude
          marker.lng requestedCourrierLocations.longitude
          marker.picture({
                "url" => "https://cdn0.iconfinder.com/data/icons/global-logistics-1-2/73/12-32.png",
                "width" => 32,
                "height" => 32
              })

          marker.infowindow " Nombre: #{courrier.name} <br>
                              Ultima Ubicacion: #{requestedCourrierLocations.location}
                              <hr>
                              Fecha de ubicacion: #{requestedCourrierLocations.created_at}  "
        end

    respond_to do |response|
        response.json { render json: @hash }
      end
  end

  def automaticCourrierRoute

    courrierName = params[:courrier_name]
    courrier = User.where(name: courrierName).last
    @requestedCourrierLocations = CourriersLocation.where(user_id: courrier.id).where(location_type: "Automatic").where("created_at >= ?", Time.zone.now.beginning_of_day)
    @hash = Gmaps4rails.build_markers(@requestedCourrierLocations) do |requestedCourrierLocations, marker|
          marker.lat requestedCourrierLocations.latitude
          marker.lng requestedCourrierLocations.longitude
          marker.picture({
                "url" => "https://cdn0.iconfinder.com/data/icons/global-logistics-1-2/73/12-32.png",
                "width" => 32,
                "height" => 32
              })

          marker.infowindow " Nombre: #{courrier.name} <br>
                              Ultima Ubicacion: #{requestedCourrierLocations.location}
                              <hr>
                              Fecha de ubicacion: #{requestedCourrierLocations.created_at}  "
        end

    respond_to do |response|
      response.json { render json: @hash }
    end
  end


  def todayAndPendentOrders
      office_id = current_user.mail_delivery_office_id
      courrierName = params[:courrier_name]

      @pendentOrders = DeliveryOrder.where(delivery_man: courrierName).where.not(latitude: nil, longitude:nil ).where(mail_delivery_office_id: office_id).where(state: "pendiente").where.not("created_at >= ?", Time.zone.now.beginning_of_day)
      @todayPendentOrders = DeliveryOrder.where(delivery_man: courrierName).where.not(latitude: nil, longitude:nil ).where(mail_delivery_office_id: office_id).where(state: "pendiente").where("created_at >= ?", Time.zone.now.beginning_of_day)
      @todayDeliveredOrders = DeliveryOrder.where(delivery_man: courrierName).where.not(latitude: nil, longitude:nil ).where(mail_delivery_office_id: office_id).where(state: "entregada").where("created_at >= ?", Time.zone.now.beginning_of_day)
      @todayDevolutionOrders = DeliveryOrder.where(delivery_man: courrierName).where.not(latitude: nil, longitude:nil ).where(mail_delivery_office_id: office_id).where(state: "devolucion").where("created_at >= ?", Time.zone.now.beginning_of_day)

      #not today pendent orders
      @hash = Gmaps4rails.build_markers(@pendentOrders) do |order, marker|
          marker.lat order.latitude
          marker.lng order.longitude

          marker.picture({
                "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=P|000|fff|",
                "width" => 35,
                "height" => 42
              })

          marker.infowindow " Estado: <label style='color:red'>#{order.state}</label><br>
                              Cargada al mensajero el: #{order.created_at}
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "
        end
        #today pendent orders
        @hash2 = Gmaps4rails.build_markers(@todayPendentOrders) do |order, marker|
          marker.lat order.latitude
          marker.lng order.longitude

          marker.picture({
                "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=P|FF0000|fff|",
                "width" => 35,
                "height" => 42
              })

          marker.infowindow " Estado: #{order.state}
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man}"
        end

        #Today delivered Orders
        @hash3 = Gmaps4rails.build_markers(@todayDeliveredOrders) do |order, marker|
          marker.lat order.latitude
          marker.lng order.longitude

          marker.picture({
                "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=E|70cc29|fff|",
                "width" => 35,
                "height" => 42
              })



          marker.infowindow " Estado: <label style='color:#70cc29'>#{order.state}</label><br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "
        end

        #Today devolutions
        @hash4 = Gmaps4rails.build_markers(@todayDevolutionOrders) do |order, marker|
          marker.lat order.latitude
          marker.lng order.longitude

          marker.picture({
                "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=D|e3ba0d|fff|",
                "width" => 35,
                "height" => 42
              })

          marker.infowindow " Estado: <label style='color:#e3ba0d'>#{order.state}</label><br>
                              Razon: #{order.devolution.devolution_reason}<br>
                              Observacion: #{order.devolution.observation}<br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "
        end



      respond_to do |response|
        response.json { render json: @hash + @hash2 + @hash3 + @hash4 }
      end

  end

  def deliveredOrdersRoute
    office_id = current_user.mail_delivery_office_id
    courrierName = params[:courrier_name]
    courrier = User.where(name: courrierName).last
    @todayDeliveredOrders = DeliveryOrder.ordenedByDeliveredDate.where(delivery_man: courrierName).where.not(latitude: nil, longitude:nil ).where(mail_delivery_office_id: office_id).where(state: ["devolucion", "entregada"]).where("created_at >= ?", Time.zone.now.beginning_of_day)
    num = 0
    @hash = Gmaps4rails.build_markers(@todayDeliveredOrders) do |order, marker|

          num = num + 1
          marker.lat order.latitude
          marker.lng order.longitude

        if order.state == "devolucion"
          marker.picture({
              "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld="+ "#{num.to_s}" +"|e3ba0d|fff|",
              "width" => 35,
              "height" => 42
            })

          marker.infowindow " Estado: <label style='color:#e3ba0d'>#{order.state}</label><br>
                              Razon: #{order.devolution.devolution_reason}<br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>

                              <hr>
                              Mensajero: #{courrierName}  "
        else
          marker.picture({
                "url" => "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld="+ "#{num.to_s}" +"|5a0|fff",
                "width" => 35,
                "height" => 42
              })
          marker.infowindow " Estado: <label style='color:#70cc29'>#{order.state}</label><br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Cargue: <label style='color:black'>#{order.charge_number}</label><br>
                              Guia Interna: <label style='color:black'>#{order.internal_guide}</label><br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero: #{courrierName}  "
        end


        end

    respond_to do |response|
        response.json { render json: @hash }
      end
  end

end
