class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update ]

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

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: "Account updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def wallet
    @user = set_user
  end
  def balance
    @user = set_user
    amount = params[:amount].to_d

    if amount <= 0
      redirect_to user_path, alert: "Invalid amount."
      return
    end

    @user.balance += amount

    if @user.save
      redirect_to user_path, notice: "Added #{amount}€ to your wallet!"
    else
      redirect_to user_path, alert: "Could not update wallet."
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :email, :phone_number, :name, :password, :password_confirmation, :age, :country, :address, :amount
    )
  end

  def welcome_email(user)
    UserMailer.send_welcome_email(user).deliver_later
  end
end
