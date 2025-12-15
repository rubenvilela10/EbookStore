class PasswordController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.update(password_params.merge(password_expired: false))
      redirect_to root_path, notice: "Password updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def password_params
    params.require(:user).permit(
      :password,
      :password_confirmation
    )
  end
end
