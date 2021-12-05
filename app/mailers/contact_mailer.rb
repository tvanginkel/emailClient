class ContactMailer < ApplicationMailer
  default from: 'tv00171@surrey.ac.uk'

  def contact_email(content, email, name, phone)
    @content = content
    @name = name
    @email = email
    @phone = phone
    mail(to: 'tv00171@surrey.ac.uk', subject: 'Contact email')
  end
end