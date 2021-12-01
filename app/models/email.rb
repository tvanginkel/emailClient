class Email < ApplicationRecord
  belongs_to :mail_box, dependent: :destroy
  validates :subject, presence: true
  validates :to, presence: true
  validates :from, presence: true
end
