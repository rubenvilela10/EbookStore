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
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    calculate_price_and_fee(@order)

    if @order.save
      register_purchase_metrics(@order)
      send_notifications(@order)

      redirect_to @order, notice: "Order successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      calculate_price_and_fee(@order)
      @order.save

      redirect_to @order, notice: "Order successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path, notice: "Order successfully destroyed."
  end

  private

  def order_params
    params.require(:order).permit(
      :buyer_id,
      :destination_address,
      :billing_address,
      :payment_status,
      order_items_attributes: [:ebook_id, :_destroy]
    )
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def calculate_price_and_fee(order)
    total = order.order_items.map { |item| item.ebook.price }.sum
    order.price = total
    order.fee = total * 0.10
  end

  def register_purchase_metrics(order)
    order.order_items.each do |item|
      metric = EbookMetric.find_or_initialize_by(ebook_id: item.ebook_id)
      metric.purchases_count += 1
      metric.save
    end
  end

  def send_notifications(order)
    Rails.logger.info "Sending purchase email to buyer #{order.buyer.email}"
    Rails.logger.info "Sending statistics email to seller"
  end
end