class Email < ApplicationRecord
  belongs_to :mail_box, dependent: :destroy
end
