require 'test_helper'

class EmailControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Login to an account
    post auth_login_url, params: { email: users(:one).email, password: '123' }

    # Test that we get the correct response
    assert_response :redirect
    assert_nil flash[:error]
  end

  test 'should not access page without authorization' do
    # Log out of the account
    get auth_logout_url

    # Try to access the contact page
    get email_inbox_url

    # Test if the response is correct
    assert_response :redirect
    assert_equal (I18n.t 'error.unauthorized'), flash[:error]
  end

  test 'should get view email page' do
    # Get the view email page
    get email_view_email_url, params: { id: emails(:one).id }

    # Test if the response was success
    assert_response :success
  end

  test 'should throw unauthorized error trying to access email' do
    # Get the view email page of an email not belonging to the logged in account
    get email_view_email_url, params: { id: emails(:two).id }

    # Test if the response is an unauthorized error
    assert_equal (I18n.t 'error.unauthorized'), flash[:error]
  end

  test 'should throw not found error' do
    # Get the view page of an email that does not exist
    get email_view_email_url, params: { id: 50 }

    # Test if the response was a not found email error
    assert_equal (I18n.t 'not_found.email'), flash[:error]
  end

  test 'should delete mailbox' do
    # Try to delete a mailbox of the user
    delete email_remove_inbox_url, params: { name: mail_boxes(:one).name }

    # Check if the response is a success
    assert_equal (I18n.t 'success.success'), flash[:notice]
  end

  test 'should throw not mailbox found error trying to delete mailbox' do
    # Try to delete a mailbox of the user
    delete email_remove_inbox_url, params: { name: 'Testing' }

    # Check if the response is a success
    assert_equal (I18n.t 'not_found.mailbox'), flash[:error]
  end

  test 'should change mailbox email is in' do
    # Move an email of the user to the 'funny' mailbox
    post email_change_inbox_url, params: { email_id: emails(:one).id, name: mail_boxes(:five).name }

    # Check if the response is a success
    assert_equal (I18n.t 'success.success'), flash[:notice]
  end

  test 'should throw mailbox not found error trying to move email' do
    # Move an email of the user to the 'funny' mailbox
    post email_change_inbox_url, params: { email_id: emails(:one).id, name: 'Testing' }

    # Check if the response is a success
    assert_equal (I18n.t 'not_found.mailbox'), flash[:error]
  end

  test 'should create email' do
    # Create an email
    post email_new_email_url,
         params: { to: users(:two).email, subject: 'This is a subject', content: 'This is the content' }

    # Check if the response is a success
    assert_equal (I18n.t 'success.success'), flash[:notice]
  end

  test 'should throw user not found when sending email' do
    # Create an email for a non existing account
    post email_new_email_url,
         params: { to: 'testing@gmail.com', subject: 'This is a subject', content: 'This is the content' }

    # Check if the response is user not found error
    assert_equal (I18n.t 'not_found.user'), flash[:error]
  end

  test 'should throw subject is empty error when sending email' do
    # Create an email without a subject
    post email_new_email_url,
         params: { to: 'testing@gmail.com', content: 'This is the content' }

    # Check if the response the corresponding error
    assert_equal (I18n.t 'empty.subject'), flash[:error]
  end

  test 'should create Sent mailbox when sending email if it is not there already' do
    # Delete the Sent mailbox of the user
    delete email_remove_inbox_url, params: { name: mail_boxes(:one).name }

    # Create an email without a subject
    post email_new_email_url,
         params: { to: 'testing@gmail.com', content: 'This is the content' }

    # Check if the response is success
    assert_equal (I18n.t 'success.success'), flash[:notice]
  end

  test 'should get the inbox page' do
    # Get the inbox page
    get email_inbox_url

    # Test if the response was success
    assert_response :success
    assert_select 'h1', 'Inbox'
  end

  test 'should create inbox' do
    # Create and inbox called Cats
    post email_inbox_url, params: { name: 'Cats' }

    # Check if the response is success
    assert_equal (I18n.t 'success.success'), flash[:notice]
  end

  test 'should throw missing inbox error when creating inbox' do
    # Create inbox without a name
    post email_inbox_url

    # Check if the response is the right error
    assert_equal (I18n.t 'empty.inbox_name'), flash[:error]
  end

  test 'should delete email' do
    # Delete an email of the user
    get email_delete_email_url, params: { id: emails(:one).id }

    # Check if the response is success
    assert_equal (I18n.t 'success.success'), flash[:notice]
  end

  test 'should throw email not found error when deleting email' do
    # Delete an email of the user
    get email_delete_email_url, params: { id: '345' }

    # Check if the response is success
    assert_equal (I18n.t 'not_found.email'), flash[:error]
  end

  test 'should throw unauthorized access error when deleting email' do
    # Delete an email of the user
    get email_delete_email_url, params: { id: emails(:two).id }

    # Check if the response is success
    assert_equal (I18n.t 'error.unauthorized'), flash[:error]
  end
end
