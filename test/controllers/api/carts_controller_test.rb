require "test_helper"

class Api::CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_carts_show_url
    assert_response :success
  end
end
