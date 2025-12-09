class Admin::OrdersController < Admin::AdminController
  before_action :authenticate_admin
  before_action :set_order, only: %i[show edit update destroy]

  layout "admin"

  def index
    @orders = Order.includes(:buyer, :ebooks).all
  end

  def show
  end

  def new
    @order = Order.new
    @order.order_items.build
    @buyers = User.buyer.order(:name)
    @ebooks = Ebook.where(status: "live")
  end

  def edit
    @buyers = User.buyer.order(:name)
    @ebooks = Ebook.where(status: "live")
  end

  def create
    @order = Order.new(order_params.except(:order_items_attributes))
    @buyers = User.buyer.order(:name)
    @ebooks = Ebook.where(status: "live")

    ebook_ids = Array(order_params.dig(:order_items_attributes)&.values)
                   .map { |h| h["ebook_id"].to_i }
                   .compact

    begin
      Admin::OrderService.new(@order).new_order_transaction!(ebook_ids)
      send_notifications(@order)
      redirect_to admin_order_path(@order), notice: "Order successfully created."
    rescue StandardError => e
      @buyers = User.buyer.order(:name)
      @ebooks = Ebook.where(status: "live")
      Rails.logger.error "ORDER CREATION ERROR: #{e.class} - #{e.message}"
      flash.now[:alert] = e.message
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @buyers = User.buyer.order(:name)
    @ebooks = Ebook.where(status: "live")
    if @order.update(order_params)
      calculate_price_and_fee(@order)
      @order.save

      redirect_to admin_order_path(@order), notice: "Order successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to admin_orders_path, notice: "Order successfully destroyed."
  end

  private

  def order_params
    params.require(:order).permit(
      :buyer_id,
      :destination_address,
      :billing_address,
      :payment_status,
      order_items_attributes: [ :ebook_id, :_destroy ]
    )
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def send_notifications(order)
    OrderMailer.new_order_forward_buyer(order).deliver_later

    order.order_items.includes(:ebook).each do |item|
      OrderMailer.new_order_forward_seller(item).deliver_later
    end
  end
end
