# frozen_string_literal: true

# Controls the home controller
class HomeController < ApplicationController
  before_action :require_login

  def index; end

  def inbox
    @mailboxes = MailBox.all
    @mailboxes.each do |mailbox|

    end
  end

  def require_login
    return if logged_in?

    puts 'You must be logged in to access this page'
    redirect_to '/auth/login'
  end

  def create_inbox
    @name = params[:name]

    @current_user_id = current_user.id
    puts "Current user id: #{@current_user_id}"
    @mailbox = MailBox.new(name: @name, user_id: @current_user_id)

    unless @mailbox.save
      flash[:error] = @mailbox.errors
      return redirect_back(fallback_location: root_path)
    end

    flash[:notice] = 'Mailbox created successfully'
    redirect_back(fallback_location: root_path)
  end

end
