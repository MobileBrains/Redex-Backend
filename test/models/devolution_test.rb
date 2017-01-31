# == Schema Information
#
# Table name: devolutions
#
#  id                            :integer          not null, primary key
#  devolution_reason             :integer
#  observation                   :text
#  delivery_order_internal_guide :string
#  user_id                       :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  image                         :string
#  delivery_order_id             :integer
#

require 'test_helper'

class DevolutionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
