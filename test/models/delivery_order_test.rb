# == Schema Information
#
# Table name: delivery_orders
#
#  id                      :integer          not null, primary key
#  radication_at           :datetime
#  delivered_at            :datetime
#  charge_number           :integer
#  delivery_man            :string
#  city                    :string
#  internal_guide          :string
#  destinatary             :string
#  address                 :string
#  client                  :string
#  externa_guide           :string
#  state                   :integer          default("pendiente")
#  image                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  latitude                :float
#  longitude               :float
#  mail_delivery_office_id :integer
#  uploaded_by             :integer
#

require 'test_helper'

class DeliveryOrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
