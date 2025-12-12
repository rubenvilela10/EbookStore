class UsersController < ApplicationController
  def new
    session[:return_to] = request.referer
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = "buyer"
    @user.status = "enable"

    if @user.save
      welcome_email(@user)
      redirect_to(session.delete(:return_to) || root_path, notice: "Account created successfully!")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :phone_number, :name, :password, :password_confirmation
    )
  end

  def welcome_email(user)
    UserMailer.send_welcome_email(user).deliver_later
  end
end
