require "rails_helper"

RSpec.describe Order, type: :model do
  include ActiveJob::TestHelper
  it_behaves_like "a model with timestamps"

  describe "after commit" do
    describe "send notifications" do
      let!(:seller) { create(:user) }
      let!(:buyer)  { create(:user) }
      let!(:ebook)  { create(:ebook, seller: seller) }

      before do
        ActionMailer::Base.deliveries.clear
      end

      it "sends email to buyer and seller on create" do
        expect do
          perform_enqueued_jobs do
            create(
              :order,
              buyer: buyer,
              order_items_attributes: [
                { ebook: ebook, price: ebook.price }
              ]
            )
          end
        end.to change { ActionMailer::Base.deliveries.count }.by(2)
      end
    end
    describe "send notifications (MOCK)" do
      let!(:seller) { create(:user) }
      let!(:buyer)  { create(:user) }
      let!(:ebook)  { create(:ebook, seller: seller) }

      let!(:buyer_mailer) { instance_double(ActionMailer::MessageDelivery) }
      let!(:seller_mailer) { instance_double(ActionMailer::MessageDelivery) }

      before do
        allow(OrderMailer).to receive(:new_order_forward_buyer).and_return(buyer_mailer)
        allow(OrderMailer).to receive(:new_order_forward_seller).and_return(seller_mailer)

        allow(buyer_mailer).to receive(:deliver_later)
        allow(seller_mailer).to receive(:deliver_later)
      end

      it "calls email mailer when order is created" do
        expect(OrderMailer).to receive(:new_order_forward_buyer).with(instance_of(Order))
        expect(OrderMailer).to receive(:new_order_forward_seller).with(instance_of(OrderItem))

        create(:order, buyer: buyer, order_items_attributes: [ { ebook: ebook, price: ebook.price } ])
      end

      it "calls mailer with correct buyer, seller and ebook" do
        expect(OrderMailer).to receive(:new_order_forward_buyer) do |order|
          expect(order.buyer). to eq(buyer)
          expect(order.order_items.first.ebook). to eq(ebook)
          buyer_mailer
        end

        expect(OrderMailer).to receive(:new_order_forward_seller) do |order_item|
          expect(order_item.ebook). to eq(ebook)
          expect(order_item.ebook.seller). to eq(seller)
          seller_mailer
        end

        create(:order, buyer: buyer, order_items_attributes: [ { ebook: ebook, price: ebook.price } ])
      end
    end
  end

  describe "validations" do
    subject(:order) { build(:order) }

    it "is valid with valid attributes" do
      expect(order).to be_valid
    end

    it "is invalid without billing address" do
      order.billing_address = nil
      expect(order).not_to be_valid
    end

    it "is invalid without destination address" do
      order.destination_address = nil
      expect(order).not_to be_valid
    end

    it "is invalid without valid payment status" do
      order.payment_status = nil
      expect(order).not_to be_valid
    end
  end
end
