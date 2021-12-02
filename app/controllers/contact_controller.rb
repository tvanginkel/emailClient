class ContactController < ApplicationController
  before_action :require_login

  def contact; end

  # Use a contact_mailer to send the contact info to and email
  def send_contact
    @content = params[:content]

    if @content == ''
      flash[:notice] = I18n.t 'empty_message'
      return redirect_back(fallback_location: root_path)
    end

    ContactMailer.with(@content).contact_email.deliver_later

    flash[:notice] = I18n.t 'success'
    redirect_back(fallback_location: root_path)
  end
end