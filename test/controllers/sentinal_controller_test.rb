require 'test_helper'

class SentinalControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sentinal_index_url
    assert_response :success
  end

end
