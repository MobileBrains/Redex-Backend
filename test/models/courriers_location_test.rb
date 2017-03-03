# == Schema Information
#
# Table name: courriers_locations
#
#  id            :integer          not null, primary key
#  latitude      :float
#  longitude     :float
#  user_id       :integer
#  location_type :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  location      :string
#  image         :string
#

require 'test_helper'

class CourriersLocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
