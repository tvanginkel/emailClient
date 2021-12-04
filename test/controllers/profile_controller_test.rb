require 'test_helper'

class ProfileControllerTest < ActionDispatch::IntegrationTest

  setup do
    post auth_register_url, params: { email: 'toni@gmail.com', password: '123' }

    assert_response :redirect
    assert_nil flash[:error]
  end

  test 'should get profile' do
    # TODO: add more tests
    get profile_profile_url
    assert_response :success
  end

  test 'should change password' do

    # Change the password
    post profile_profile_url, params: { password: 'password' }

    # Test if we get the correct response
    assert_response :redirect
    assert_nil flash[:error]
    assert_not_nil flash[:notice]

    # Try to login with the new password
    post auth_login_url, params: { email: 'toni@gmail.com', password: 'password' }
    assert_response :redirect
    assert_nil flash[:error]
    assert_not_nil flash[:notice]
  end
end
