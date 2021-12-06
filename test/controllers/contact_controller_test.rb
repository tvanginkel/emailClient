require 'test_helper'

class ContactControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Login to an account
    post auth_login_url, params: { email: users(:one).email, password: '123' }

    # Test that we get the correct response
    assert_response :redirect
    assert_nil flash[:error]
  end

  test 'should get contact page' do
    # Get the contact page
    get contact_contact_url

    assert_response :success
    assert_select 'h1', 'Contact'
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

  test 'should send mailer' do
    # Send the contact mail
    post contact_contact_path, params: { content: 'This is the message', name: 'Testing', phone: '012345678' }

    # Test if the response is a success
    assert_equal (I18n.t 'success.success'), flash[:notice]
  end

  test 'should throw error of missing name' do
    # Send the contact mail without a name
    post contact_contact_path, params: { content: 'This is the message', phone: '012345678' }

    # Test if the response is a missing name error
    assert_equal (I18n.t 'empty.name'), flash[:error]
  end

  test 'should throw error of missing content' do
    # Send contact mail without content
    post contact_contact_path, params: { name: 'Testing', phone: '012345678' }

    # Test if the response is a missing content error
    assert_equal (I18n.t 'empty.message'), flash[:error]
  end
end
