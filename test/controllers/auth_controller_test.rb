require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest
  test 'should get login page' do
    get auth_login_url
    assert_response :success
  end

  test 'should get register page' do
    get auth_register_url
    assert_response :success
  end

  test 'should create account' do
    # Create an account
    post auth_register_url, params: { email: 'test@gmail.com', password: '123' }

    # Test that we get the correct response
    assert_response :redirect
    assert_nil flash[:error]
  end

  test 'should login to account' do
    # Create an account
    post auth_register_url, params: { email: 'test@gmail.com', password: '123' }

    # Log in to the account
    post auth_login_url, params: { email: 'test@gmail.com', password: '123' }

    # Test that we get the correct response
    assert_response :redirect
    assert_nil flash[:error]
    assert_redirected_to root_path
  end

  test 'should log out of account' do
    # Create an account
    post auth_register_url, params: { email: 'test@gmail.com', password: '123' }

    # Log out of the account
    get auth_logout_url

    # Test that we get the correct response
    assert_equal (I18n.t 'success.logout'), flash[:notice]
    assert_redirected_to auth_login_url
  end
end
