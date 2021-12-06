require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test 'should send contact mail' do
    # Create the email
    email = ContactMailer.contact_email('This is the message', users(:one).email, 'Toni van Ginkel', '012345678')

    # Test if the email was sent
    assert_emails 1 do
      email.deliver_now
    end

    # Test if the content of the email is right
    assert_equal ['contact@emailClient.com'], email.from
    assert_equal ['contact@emailClient.com'], email.to
    assert_equal 'Contact email', email.subject
  end
end
