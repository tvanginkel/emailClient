require 'test_helper'

class ProfileControllerTest < ActionDispatch::IntegrationTest

  setup do
    # Create an account for testing
    # TODO: Use user from fixtures
    post auth_register_url, params: { email: 'toni@gmail.com', password: '123' }

    # Test that we get the correct response
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

  test 'delete account' do
    # Delete the account
    delete profile_profile_url

    # Test if we get the correct response
    assert_response :redirect
    assert_nil flash[:error]
    assert_not_nil flash[:notice]

    # Try to login to the account, should throw an error as it shouldn't exist anymore
    post auth_login_url, params: { email: 'toni@gmail.com', password: 'password' }
    assert_response :redirect
    assert_equal (I18n.t 'error.incorrect_credentials'), flash[:error]
  end
end
