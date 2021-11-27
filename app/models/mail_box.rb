# frozen_string_literal: true

# MailBox model
class MailBox < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :emails
end
