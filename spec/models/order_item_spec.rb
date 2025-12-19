require "rails_helper"

RSpec.describe OrderItem, type: :model do
  it_behaves_like "a model with timestamps"
  describe "associations" do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:ebook) }
  end

  describe "validations" do
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:fee).is_greater_than_or_equal_to(0) }
  end

  describe "before_validation :assign_price_and_fee" do
    let(:ebook) { create(:ebook, price: 100) }
    let(:order) { create(:order) }

    it "assigns price and fee from ebook when nil" do
      order_item = build(:order_item, ebook: ebook, order: order, price: nil, fee: nil)

      order_item.valid?

      expect(order_item.price).to eq(100)
      expect(order_item.fee).to eq(10.0)
    end

    it "does not override existing price and fee" do
      order_item = build(
        :order_item,
        ebook: ebook,
        order: order,
        price: 80,
        fee: 5
      )

      order_item.valid?

      expect(order_item.price).to eq(80)
      expect(order_item.fee).to eq(5)
    end
  end
end
