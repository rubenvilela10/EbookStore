class OrdersController < ApplicationController
  before_action :set_order, only: [ :show, :edit, :update, :delete ]

  def index
    @orders = Order.where(buyer_id: current_user.id)
  end

  def show
  end

  def edit
  end

  def update
  end

  def delete
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :id
    )
  end
end
