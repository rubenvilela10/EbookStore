require "browser"
class OrderService
  FEE = 0.10

  def initialize(order, request:)
    @order = order
    @buyer = order.buyer
    @request = request
  end

  def new_order_transaction!(ebook_ids)
    raise "You must select at least one ebook." if ebook_ids.empty?

    ebook_ids = Array(ebook_ids).map(&:to_i).reject(&:zero?)

    ebooks = Ebook.where(id: ebook_ids).index_by(&:id)

    # Check for ebooks that does not exist
    missing_ids = ebook_ids - ebooks.keys
    raise ActiveRecord::RecordInvalid.new(@order), "Invalid ebook(s): #{missing_ids.join(", ")}" if missing_ids.any?

    total_price = ebook_ids.sum { |id| ebooks[id].price.to_d }
    total_fee   = ebook_ids.sum { |id| ebooks[id].price.to_d * FEE }

    ActiveRecord::Base.transaction do
      validate_balance!(total_price)

      @buyer.update!(balance: @buyer.balance - total_price)

      @order.update!(
        total_price: total_price,
        total_fee: total_fee
      )

      ebook_ids.each do |ebook_id|
        ebook = ebooks[ebook_id]

        @order.order_items.create!(
          ebook_id: ebook.id,
          price: ebook.price.to_d,
          fee: ebook.price.to_d * FEE
        )

        pay_seller!(ebook)
      end

      register_metrics!
    end
  end

  private

  def validate_balance!(price)
    if @buyer.balance < price
      raise ActiveRecord::RecordInvalid.new(@order), "Buyer does not have enough balance"
    end
  end

  def pay_seller!(ebook)
    seller = ebook.seller
    return if seller.id == @buyer.id

    seller_earnings = ebook.price.to_d * (1 - FEE)
    seller.update!(balance: seller.balance + seller_earnings)
  end

  def register_metrics!
    @order.order_items.each do |item|
      browser  = Browser.new(@request.user_agent)
      location = Geocoder.search(@request.remote_ip).first

      EbookMetric.create!(
        ebook_id: item.ebook_id,
        event_type: "purchase",
        ip: @request.remote_ip,
        user_agent: @request.user_agent,
        extra_data: {
          order: {
            id: @order.id
          },
          browser: {
            name: browser.name,
            version: browser.full_version,
            platform: browser.platform.name,
            device: browser.device.name
          },
          location: {
            country: location&.country,
            city: location&.city,
            latitude: location&.latitude,
            longitude: location&.longitude
          }
        }.to_json
      )

      stat = EbookStat.find_or_create_by!(ebook_id: item.ebook_id)
      stat.increment!(:purchases_count)
    end
  end
end
