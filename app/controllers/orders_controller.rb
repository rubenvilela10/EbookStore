class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show]

  def index
    @orders = current_user.orders.includes(order_items: :ebook)
  end

  def show
  end

  def create
    ebook_ids = Array(params[:ebook_ids]).reject(&:blank?)

    @order = current_user.orders.build(
      destination_address: params[:destination_address],
      billing_address: params[:billing_address],
      payment_status: "paid"
    )

    OrderService.new(@order, request: request)
                .new_order_transaction!(ebook_ids)

    redirect_to order_path(@order), notice: "Order created successfully."

  rescue StandardError => e
    Rails.logger.error e.message
    redirect_to ebooks_path, alert: e.message
  end

  private

  def authenticate_user!
    return if current_user.present?

    redirect_to login_path, alert: "You must be logged in"
  end

  def set_order
    @order = current_user.orders.find(params[:id])
  end
end
