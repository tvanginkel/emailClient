require "test_helper"

class MailBoxTest < ActiveSupport::TestCase
  test 'should save mailbox' do
    mailbox = MailBox.new

    mailbox.name = 'test'
    mailbox.user_id = users(:one).id

    mailbox.save

    assert mailbox.valid?
  end

  test 'should save mailbox without name and give it a default value' do
    mailbox = MailBox.new

    mailbox.user_id = users(:one).id

    mailbox.save

    assert mailbox.valid?

    # Check if the mailbox name has a default value
    assert_equal 'no_name', mailbox.name
  end

  test 'should not save mailbox with invalid user_id' do
    mailbox = MailBox.new

    mailbox.user_id = 234

    mailbox.save

    assert_not mailbox.valid?
  end

  test 'should not save mailbox without user_id' do
    mailbox = MailBox.new

    mailbox.save

    assert_not mailbox.valid?
  end
end
