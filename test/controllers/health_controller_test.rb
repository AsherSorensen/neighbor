require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  test "should get check" do
    get "/health"
    assert_response :success
  end
end
