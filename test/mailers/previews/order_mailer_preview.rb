# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  def new_order_forward_buyer
    order = Order.last
    OrderMailer.new_order_forward_buyer(order)
  end

  def new_order_forward_seller
    order_item = OrderItem.last
    OrderMailer.new_order_forward_seller(order_item)
  end
end
