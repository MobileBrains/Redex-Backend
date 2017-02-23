class MapsController < ApplicationController

  def deliveryOrders
      @delivery_orders = DeliveryOrder.where.not(latitude: nil, longitude:nil )
      @hash = Gmaps4rails.build_markers(@delivery_orders) do |order, marker|
        marker.lat order.latitude
        marker.lng order.longitude

        if order.state == "entregada"
          marker.picture({
              "url" => "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/32/Map-Marker-Marker-Outside-Chartreuse-icon.png",
              "width" => 32,
              "height" => 32
            })
        end
        if order.state == "devolucion"
          marker.picture({
              "url" => "http://www.myiconfinder.com/uploads/iconsets/32-32-369f997cef4f440c5394ed2ae6f8eecd.png",
              "width" => 32,
              "height" => 32
            })

        end

        marker.infowindow "Estado: #{order.state}
                            <hr>
                          Guia Interna: #{order.internal_guide} <br>
                          Destinatario: #{order.destinatary} <br>
                          Direccion: #{order.address} <br>
                          Fecha de entrega: #{order.delivered_at}
                            <hr>
                          Mensajero Encargado: #{order.delivery_man}
                          "
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

end
