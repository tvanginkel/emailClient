class ContactController < ApplicationController
  before_action :require_login

  def contact; end

  # Use a contact_mailer to send the contact info to and email
  def send_contact
    @content = params[:content]

    ContactMailer.contact_email.deliver
    flash[:notice] = 'Email sent'
    redirect_back(fallback_location: root_path)
  end
end