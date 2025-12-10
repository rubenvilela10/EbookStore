class Admin::OrdersController < Admin::AdminController
  before_action :authenticate_admin!
  before_action :set_order, only: %i[show edit update destroy]

  layout "admin"

  def index
    @orders = Order.includes(:buyer, :ebooks).all
  end

  def show
  end

  def new
    load_dependencies
    @order = Order.new
    @order.order_items.build
  end

  def edit
    @buyers = User.buyer.order(:name)
    @ebooks = Ebook.where(status: "live")
  end

  def create
    load_dependencies
    @order = Order.new(order_params.except(:ebook_ids))
    ebook_ids = Array(order_params[:ebook_ids]).reject(&:blank?).map(&:to_i)

    begin
      Admin::OrderService.new(@order).new_order_transaction!(ebook_ids)
      send_notifications(@order)

      redirect_to admin_order_path(@order), notice: "Order successfully created."

    rescue StandardError => e
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

  def load_dependencies
    @buyers = User.buyer.order(:name)
    @ebooks = Ebook.where(status: "live")
  end

  def order_params
    params.require(:order).permit(
      :buyer_id,
      :destination_address,
      :billing_address,
      :payment_status,
      ebook_ids: []
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
