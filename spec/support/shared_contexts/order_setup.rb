RSpec.shared_context "when order setup" do
  let(:seller) { create(:user, :seller) }
  let(:buyer)  { create(:user, :buyer, balance: 100) }
  let!(:ebook) { create(:ebook, :live, seller: seller) }

  let(:order_items_attributes) do
    [
      { ebook: ebook, price: ebook.price }
    ]
  end

  let(:order) do
    create(:order, buyer: buyer, order_items_attributes: order_items_attributes)
  end

  before do
    ActionMailer::Base.deliveries.clear
  end
end
