# == Schema Information
#
# Table name: mail_delivery_companies
#
#  id         :integer          not null, primary key
#  name       :string
#  address    :string
#  email      :string
#  phone      :integer
#  latitude   :float
#  longitude  :float
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string
#

require 'test_helper'

class MailDeliveryCompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
