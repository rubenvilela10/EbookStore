class OrderMailer < ApplicationMailer
  default from: "r.vilela@runtime-revolution.com"

  def new_order_forward_seller(order_item)
    @order_item = order_item
    @order = order_item.order
    @ebook = order_item.ebook
    @seller = @ebook.seller

    mail(
      to: @seller.email,
      subject: "Your ebook \"#{@ebook.title}\" has been purchased!"
    )
  end

  def new_order_forward_buyer(order)
    @order = order
    @buyer = order.buyer

    mail(
      to: @buyer.email,
      subject: "Your order #{order.id} is confirmed!"
    )
  end
end
