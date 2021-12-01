# frozen_string_literal: true

# MailBox model
class MailBox < ApplicationRecord

  # Relations
  belongs_to :user
  has_many :emails, dependent: :destroy

  # Validation
  validates :name, presence: true
end
