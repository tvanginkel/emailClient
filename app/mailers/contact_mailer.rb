class ContactMailer < ApplicationMailer
  default from: 'tginkel1@gmail.com'

  def contact_email
    mail(to: 'tv00171@surrey.ac.uk', subject: 'Email Client Contact form')
  end

end