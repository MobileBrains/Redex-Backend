require 'test_helper'

class ManagementReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @management_report = management_reports(:one)
  end

  test "should get index" do
    get management_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_management_report_url
    assert_response :success
  end

  test "should create management_report" do
    assert_difference('ManagementReport.count') do
      post management_reports_url, params: { management_report: { client_id: @management_report.client_id, description: @management_report.description, link: @management_report.link, name: @management_report.name, user_id: @management_report.user_id } }
    end

    assert_redirected_to management_report_url(ManagementReport.last)
  end

  test "should show management_report" do
    get management_report_url(@management_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_management_report_url(@management_report)
    assert_response :success
  end

  test "should update management_report" do
    patch management_report_url(@management_report), params: { management_report: { client_id: @management_report.client_id, description: @management_report.description, link: @management_report.link, name: @management_report.name, user_id: @management_report.user_id } }
    assert_redirected_to management_report_url(@management_report)
  end

  test "should destroy management_report" do
    assert_difference('ManagementReport.count', -1) do
      delete management_report_url(@management_report)
    end

    assert_redirected_to management_reports_url
  end
end
