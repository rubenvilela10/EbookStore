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

    ebook_ids = Array(order_params.dig(:order_items_attributes)&.values).map { |h| h["ebook_id"].to_i }.compact

    ebooks = Ebook.where(id: ebook_ids).index_by(&:id)

    total_price = ebook_ids.sum { |id| ebooks[id]&.price.to_f }
    total_fee   = ebook_ids.sum { |id| (ebooks[id]&.price.to_f * 0.10) }

    ActiveRecord::Base.transaction do
      @order.total_price = total_price
      @order.total_fee   = total_fee

      @order.save!

      ebook_ids.each do |ebook_id|
        ebook = ebooks[ebook_id]
        raise ActiveRecord::RecordNotFound, "Ebook #{ebook_id} not found" unless ebook

        @order.order_items.create!(
          ebook_id: ebook.id,
          price:    ebook.price,
          fee:      (ebook.price.to_f * 0.10)
        )
      end

      register_purchase_metrics(@order)
      send_notifications(@order)
    end

    redirect_to admin_order_path(@order), notice: "Order successfully created."
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    @buyers = User.buyer.order(:name)
    @ebooks = Ebook.where(status: "live")
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
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

  def calculate_price_and_fee(order)
    order.total_price = order.order_items.sum(&:price)
    order.total_fee   = order.order_items.sum(&:fee)
  end

  def register_purchase_metrics(order)
    order.order_items.each do |item|
      # log event
      EbookMetric.create!(
        ebook_id: item.ebook_id,
        event_type: "purchase",
        ip: request.remote_ip,
        user_agent: request.user_agent,
        extra_data: { order_id: order.id }.to_json
      )

      stat = EbookStat.find_or_create_by!(ebook_id: item.ebook_id)
      stat.increment!(:purchases_count)
    end
  end

  def send_notifications(order)
    OrderMailer.new_order_forward_buyer(order).deliver_later

    order.order_items.includes(:ebook).each do |item|
      OrderMailer.new_order_forward_seller(item).deliver_later
    end
  end
end
