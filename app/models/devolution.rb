# == Schema Information
#
# Table name: devolutions
#
#  id                            :integer          not null, primary key
#  devolution_reason             :integer
#  observation                   :text
#  delivery_order_internal_guide :integer
#  user_id                       :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class Devolution < ApplicationRecord

  belongs_to :user

  scope :devolutions_count, -> (internal_guide) { where(:delivery_order_internal_guide => internal_guide).count }

  enum devolution_reason: { DireccionErrada: 0,
                PermaneceCerrado: 1,
                ClienteNoConocido: 2,
                TrasladoPersona: 3,
                DireccionIncompleta: 4,
                TrasladoEmpresa: 5,
                DesordenPublicoODificilAcceso: 6,
                Demolido: 7,
                Rehusado: 8
              }

end
