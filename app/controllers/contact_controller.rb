class ContactController < ApplicationController
  before_action :require_login

  def contact; end

  # Use a contact_mailer to send the contact info to and email
  def send_contact
    content = params[:content]
    name = params[:name]
    phone = params[:phone]
    email = current_user.email

    if content == ''
      flash[:notice] = I18n.t 'empty.message'
      return redirect_back(fallback_location: root_path)
    end

    if name == ''
      flash[:notice] = I18n.t 'empty.name'
      return redirect_back(fallback_location: root_path)
    end

    ContactMailer.contact_email(content, email, name, phone).deliver_later

    flash[:notice] = I18n.t 'success.success'
    redirect_back(fallback_location: root_path)
  end
end