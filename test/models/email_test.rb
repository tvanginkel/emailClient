require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  test 'should save valid email' do
    email = Email.new

    email.to = users(:one).email
    email.subject = 'subject'
    email.from = users(:two).email
    email.content = 'this is the content'
    email.mail_box_id = mail_boxes(:one).id

    email.save

    assert email.valid?
  end

  test 'should not save email without "to"' do
    email = Email.new

    email.subject = 'subject'
    email.from = users(:two).email
    email.content = 'this is the content'
    email.mail_box_id = mail_boxes(:one).id

    email.save

    assert_not email.valid?
  end

  test 'should not save email without "from"' do
    email = Email.new

    email.to = users(:one).email
    email.subject = 'subject'
    email.content = 'this is the content'
    email.mail_box_id = mail_boxes(:one).id

    email.save

    assert_not email.valid?
  end

  test 'should save email without subject and make it the default subject' do
    email = Email.new

    email.to = users(:one).email
    email.from = users(:two).email
    email.content = 'this is the content'
    email.mail_box_id = mail_boxes(:one).id

    email.save

    assert email.valid?

    assert_equal 'No subject', email.subject
  end

  test 'should save email without content' do
    email = Email.new

    email.to = users(:one).email
    email.from = users(:two).email
    email.mail_box_id = mail_boxes(:one).id

    email.save

    assert email.valid?
  end

  test 'should not save email without mailbox_id' do
    email = Email.new

    email.to = users(:one).email
    email.from = users(:two).email
    email.content = 'this is the content'

    email.save

    assert_not email.valid?
  end

  test 'should not save email without finding the mailbox_id' do
    email = Email.new

    email.to = users(:one).email
    email.from = users(:two).email
    email.content = 'this is the content'
    email.mail_box_id = 234

    email.save

    assert_not email.valid?
  end
end
