require 'test_helper'

class ProfileControllerTest < ActionDispatch::IntegrationTest

  setup do
    # Login to an account
    post auth_login_url, params: { email: users(:one).email, password: '123' }

    # Test that we get the correct response
    assert_response :redirect
    assert_nil flash[:error]
  end

  test 'should get profile' do
    get profile_profile_url

    assert_response :success
    assert_select 'h1', 'Profile'
  end

  test 'should change password' do
    # Change the password
    patch profile_profile_url, params: { password: 'password' }

    # Test if we get the correct response
    assert_response :redirect
    assert_equal (I18n.t 'success.success'), flash[:notice]

    # Try to login with the new password
    post auth_login_url, params: { email: 'toni@gmail.com', password: 'password' }

    assert_equal (I18n.t 'error.incorrect_credentials'), flash[:error]
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

  test 'should not access page without authorization' do
    # Log out of the account
    get auth_logout_path

    # Try to access the contact page
    get contact_contact_path

    # Test if the response is correct
    assert_response :redirect
    assert_equal (I18n.t 'error.unauthorized'), flash[:error]
  end
end
