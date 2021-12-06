require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should save valid user' do
    user = User.new

    user.email = 'test@gmail.com'
    user.password = 'password'

    user.save

    assert user.valid?
  end

  test 'should not save user without password' do
    user = User.new

    user.email = 'test@gmail.com'

    user.save

    assert_not user.valid?
  end

  test 'should not save user without email' do
    user = User.new

    user.password = 'password'

    user.save

    assert_not user.valid?
  end

  test 'should not save user with invalid email format' do
    user = User.new

    user.email = 'not and email'
    user.password = 'password'

    user.save

    assert_not user.valid?
  end
end
