class SessionsController < ApplicationController
  def new
    session[:return_to] = request.referer
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user&.authenticate(params[:password])
      if user.password_expired?
        redirect_to edit_password_path(user), alert: "Your password has expired. Please update it."
        return
      end
      session[:user_id] = user.id
      redirect_to(session.delete(:return_to) || root_path, notice: "Logged in!")
    else
      render :new, status: :unprocessable_entity, notice: "Invalid email or password."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully."
  end
end
