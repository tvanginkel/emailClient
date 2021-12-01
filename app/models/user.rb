# frozen_string_literal: true

# User model
class User < ApplicationRecord

  # Relations
  has_many :mail_boxes, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
  validates :password, presence: true
end
