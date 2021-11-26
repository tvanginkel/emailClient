# frozen_string_literal: true

# User model
class User < ApplicationRecord
  has_many :mail_boxes
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
end
