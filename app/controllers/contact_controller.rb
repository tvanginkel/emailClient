class ContactController < ApplicationController
  def contact; end

  # Use a mailer to send the contact info to and email
  def send_contact
    @content = params[:content]
  end
end