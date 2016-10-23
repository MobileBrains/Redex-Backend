require 'test_helper'

class DeliveryOrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get import" do
    get delivery_orders_import_url
    assert_response :success
  end

end
