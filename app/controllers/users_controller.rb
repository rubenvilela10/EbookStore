class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = "buyer"
    @user.status = "enable"

    if @user.save
      redirect_to root_path, notice: "Account created successfully!"
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
end
