class SellersController < ApplicationController
  def new
    @seller = current_user || User.new
  end

  def create
    if current_user
      if current_user.update(role: "seller")
        redirect_to user_path(current_user), notice: "Congratulations, you are now a seller!"
      else
        render :new, status: :unprocessable_entity
      end
    else
      @user = User.new(seller_params.merge(role: "seller", status: "enabled", balance: 0))

      if @user.save
        session[:user_id] = @user.id
        redirect_to user_path, notice: "Your seller account has been created!"
      end

    end
  end

  private

  def seller_params
    params.require(:seller).permit(
      :name, :age, :phone_number, :email, :address, :country, :password, :password_confirmation
    )
  end
end
