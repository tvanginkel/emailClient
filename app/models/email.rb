class Email < ApplicationRecord

  # Relations
  belongs_to :mail_box

  # Validations
  validates :subject, presence: true
  validates :to, presence: true
  validates :from, presence: true
end
