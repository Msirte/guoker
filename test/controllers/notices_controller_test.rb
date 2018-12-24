require 'test_helper'

class NoticesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get notices_new_url
    assert_response :success
  end

  test "should get create" do
    get notices_create_url
    assert_response :success
  end

  test "should get edit" do
    get notices_edit_url
    assert_response :success
  end

  test "should get update" do
    get notices_update_url
    assert_response :success
  end

  test "should get destroy" do
    get notices_destroy_url
    assert_response :success
  end

end
