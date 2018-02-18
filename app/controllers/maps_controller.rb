class MapsController < ApplicationController

  def deliveryOrders
      office_id = current_user.mail_delivery_office_id
      @delivery_orders = DeliveryOrder.where.not(latitude: nil, longitude:nil ).where("created_at >= ?", Time.zone.now.beginning_of_day).where(mail_delivery_office_id: office_id)
      @pendent_orders = DeliveryOrder.where.not(latitude: nil, longitude:nil ).where("created_at >= ?", Time.zone.now.beginning_of_day).where(mail_delivery_office_id: office_id)
      @hash = Gmaps4rails.build_markers(@delivery_orders) do |order, marker|
        marker.lat order.latitude
        marker.lng order.longitude

        if order.state == "pendiente"
          marker.infowindow "Estado: #{order.state}<br>
                            Cargada al mensajero el: #{order.created_at}
                            <hr>
                            Guia Interna: #{order.internal_guide} <br>
                            Destinatario: #{order.destinatary} <br>
                            Direccion: #{order.address} <br>
                            <hr>
                            Mensajero Encargado: #{order.delivery_man} "
        end

        if order.state == "entregada"
          marker.picture({
              "url" => "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/32/Map-Marker-Marker-Outside-Chartreuse-icon.png",
              "width" => 32,
              "height" => 32
            })
          marker.infowindow " Estado: #{order.state}<br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Guia Interna: #{order.internal_guide} <br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>

                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "
        end
        if order.state == "devolucion"
          marker.picture({
              "url" => "http://www.myiconfinder.com/uploads/iconsets/32-32-369f997cef4f440c5394ed2ae6f8eecd.png",
              "width" => 32,
              "height" => 32
            })
          marker.infowindow " Estado: #{order.state}<br>
                              Razon: #{order.devolution.devolution_reason}<br>
                              Observacion: #{order.devolution.observation}<br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Guia Interna: #{order.internal_guide} <br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "

        end


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
      puts("#{@courrier}")
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
                "url" => "https://chart.googleapis.com/chart?chst=d_bubble_text_small&chld=bb|P|000|fff",
                "width" => 100,
                "height" => 42
              })

          marker.infowindow " Estado: #{order.state}<br>
                              Cargada al mensajero el: #{order.created_at}
                              <hr>
                              Guia Interna: #{order.internal_guide} <br>
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
                "url" => "https://chart.googleapis.com/chart?chst=d_bubble_text_small&chld=bb|P|F77|000",
                "width" => 100,
                "height" => 42
              })

          marker.infowindow " Estado: #{order.state}
                              <hr>
                              Guia Interna: #{order.internal_guide} <br>
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
                "url" => "https://chart.googleapis.com/chart?chst=d_bubble_text_small&chld=bb|E|5a0|000",
                "width" => 100,
                "height" => 42
              })



          marker.infowindow " Estado: #{order.state}<br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Guia Interna: #{order.internal_guide} <br>
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
                "url" => "https://chart.googleapis.com/chart?chst=d_bubble_text_small&chld=bb|D|FFA500|000",
                "width" => 100,
                "height" => 42
              })

          marker.infowindow " Estado: #{order.state}<br>
                              Razon: #{order.devolution.devolution_reason}<br>
                              Observacion: #{order.devolution.observation}<br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Guia Interna: #{order.internal_guide} <br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>
                              <hr>
                              Mensajero Encargado: #{order.delivery_man} "
        end

      respond_to do |response|
        response.json { render json: @hash + @hash2 + @hash3 + @hash4}
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
              "url" => "https://chart.googleapis.com/chart?chst=d_bubble_text_small&chld=bb|"+ "#{num.to_s}" +"|FFA500|000",
              "width" => 100,
              "height" => 42
            })

          marker.infowindow " Estado: #{order.state} <br>
                              Razon: #{order.devolution.devolution_reason}<br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Guia Interna: #{order.internal_guide} <br>
                              Destinatario: #{order.destinatary} <br>
                              Direccion: #{order.address} <br>

                              <hr>
                              Mensajero: #{courrierName}  "
        else
          marker.picture({
                "url" => "https://chart.googleapis.com/chart?chst=d_bubble_text_small&chld=bb|"+ "#{num.to_s}" +"|5a0|000",
                "width" => 100,
                "height" => 42
              })
          marker.infowindow " Estado: #{order.state} <br>
                              Fecha de entrega: #{order.delivered_at}<br>
                              <hr>
                              Guia Interna: #{order.internal_guide} <br>
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
