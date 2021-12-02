class ContactMailer < ApplicationMailer
  default from: 'tv00171@surrey.ac.uk'

  def contact_email
    @content = params[:content] #TODO fix error
    mail(to: 'tv00171@surrey.ac.uk', subject: 'Contact email')
  end
end