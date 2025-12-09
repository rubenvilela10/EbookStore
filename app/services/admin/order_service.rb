module Admin
  class OrderService
    FEE = 0.10

    def initialize(order)
      @order = order
      @buyer = order.buyer
    end

    def new_order_transaction!(ebook_ids)
      ebooks = Ebook.where(id: ebook_ids).index_by(&:id)

      total_price = ebook_ids.sum { |id| ebooks[id].price.to_f }
      total_fee   = ebook_ids.sum { |id| ebooks[id].price.to_f * FEE }

      ActiveRecord::Base.transaction do
        validate_balance!(total_price)

        # Debit buyer
        @buyer.update!(balance: @buyer.balance - total_price)

        # Save order
        @order.update!(
          total_price: total_price,
          total_fee: total_fee
        )

        ebook_ids.each do |ebook_id|
          ebook = ebooks[ebook_id]

          item = @order.order_items.create!(
            ebook_id: ebook.id,
            price: ebook.price,
            fee: ebook.price.to_f * FEE
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

      seller_earnings = ebook.price.to_f * (1 - FEE)
      seller.update!(balance: seller.balance + seller_earnings)
    end

    def register_metrics!
      @order.order_items.each do |item|
        EbookMetric.create!(
          ebook_id: item.ebook_id,
          event_type: "purchase",
          ip: nil,
          user_agent: nil,
          extra_data: { order_id: @order.id }.to_json
        )

        stat = EbookStat.find_or_create_by!(ebook_id: item.ebook_id)
        stat.increment!(:purchases_count)
      end
    end
  end
end
