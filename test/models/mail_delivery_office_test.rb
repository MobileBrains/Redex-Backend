# == Schema Information
#
# Table name: mail_delivery_offices
#
#  id                       :integer          not null, primary key
#  name                     :string
#  address                  :string
#  email                    :string
#  phone                    :integer
#  latitude                 :float
#  longitude                :float
#  user_id                  :integer
#  image                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  mail_delivery_company_id :integer
#

require 'test_helper'

class MailDeliveryOfficeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
