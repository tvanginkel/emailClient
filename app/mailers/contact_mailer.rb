class ContactMailer < ApplicationMailer
  default from: 'tv00171@surrey.ac.uk'

  def contact_email(content, name)
    @content = content
    @name = name
    mail(to: 'tv00171@surrey.ac.uk', subject: 'Contact email')
  end
end