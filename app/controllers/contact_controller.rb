class ContactController < ApplicationController
  before_action :require_login

  def contact; end

  # Use a contact_mailer to send the contact info to and email
  def send_contact
    content = params[:content]
    name = current_user.email

    if content == ''
      flash[:notice] = I18n.t 'empty_message'
      return redirect_back(fallback_location: root_path)
    end

    ContactMailer.contact_email(content, name).deliver_later

    flash[:notice] = I18n.t 'success'
    redirect_back(fallback_location: root_path)
  end
end