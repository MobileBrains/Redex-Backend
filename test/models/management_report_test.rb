# == Schema Information
#
# Table name: management_reports
#
#  id          :integer          not null, primary key
#  name        :string
#  link        :string
#  description :string
#  user_id     :integer
#  client_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ManagementReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
