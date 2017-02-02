# == Schema Information
#
# Table name: delivery_orders
#
#  id             :integer          not null, primary key
#  radication_at  :datetime
#  delivered_at   :datetime
#  charge_number  :integer
#  delivery_man   :string
#  city           :string
#  internal_guide :string
#  destinatary    :string
#  adderss        :string
#  client         :string
#  externa_guide  :string
#  state          :integer          default("pendiente")
#  image          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class DeliveryOrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
