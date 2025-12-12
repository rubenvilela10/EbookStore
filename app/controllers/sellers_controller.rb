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

  def statistics
    set_seller

    @ebooks_count = Ebook.where(seller_id: @seller.id).count

    @total_views = EbookStat
      .joins(:ebook)
      .where(ebooks: { seller_id: @seller.id })
      .sum(:views_count)

    @total_downloads = EbookStat
      .joins(:ebook)
      .where(ebooks: { seller_id: @seller.id })
      .sum(:downloads_count)

    @total_revenue = OrderItem
      .joins(:ebook)
      .where(ebooks: { seller_id: @seller.id })
      .sum("order_items.price - order_items.fee")

    @top_ebooks_sold = Ebook
      .joins(:ebook_stat)
      .where(seller_id: @seller.id)
      .order("ebook_stats.purchases_count DESC")
      .limit(5)

    @top_ebooks_viewed = Ebook
      .joins(:ebook_stat)
      .where(seller_id: @seller.id)
      .order("ebook_stats.views_count DESC")
      .limit(5)
  end

  private

  def set_seller
    @seller = current_user
  end

  def seller_params
    params.require(:seller).permit(
      :name, :age, :phone_number, :email, :address, :country, :password, :password_confirmation
    )
  end
end
