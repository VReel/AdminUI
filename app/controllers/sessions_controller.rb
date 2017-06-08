class SessionsController < ApplicationController
  skip_before_action :redirect_anonymous, only: :create

  def create
    session[:api_server] = params[:api_server]

    if connection.sign_in(params[:email], params[:password])
      redirect_to stats_path
    else
      flash.now[:alert] = connection.get_error_message
      render :new
    end
  end

  def destroy
    session[:uid] = nil
    session['access-token'] = nil
    session[:client] = nil

    redirect_to '/'
  end
end
