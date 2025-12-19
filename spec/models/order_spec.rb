require "rails_helper"

RSpec.describe Order, type: :model do
  include ActiveJob::TestHelper
  it_behaves_like "a model with timestamps"

  describe "after commit notifications" do
    include_context "when order setup"

    it "sends emails to buyer and seller on create" do
      expect do
        perform_enqueued_jobs do
          order
        end
      end.to change { ActionMailer::Base.deliveries.count }.by(3) # 1 more due to welcome email when creating a buyer
    end

    context "when mocked mailers" do
      let!(:buyer_mailer)  { instance_double(ActionMailer::MessageDelivery) }
      let!(:seller_mailer) { instance_double(ActionMailer::MessageDelivery) }

      before do
        allow(OrderMailer).to receive_messages(new_order_forward_buyer: buyer_mailer, new_order_forward_seller: seller_mailer)

        allow(buyer_mailer).to receive(:deliver_later)
        allow(seller_mailer).to receive(:deliver_later)
      end

      it "calls buyer email when order is created" do
        expect(OrderMailer).to receive(:new_order_forward_buyer).with(instance_of(described_class)) # rubocop:disable RSpec/MessageSpies

        order
      end

      it "calls seller email when order is created" do
        expect(OrderMailer).to receive(:new_order_forward_seller).with(instance_of(OrderItem)) # rubocop:disable RSpec/MessageSpies

        order
      end

      it "calls mailer with correct buyer, seller and ebook" do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        expect(OrderMailer).to receive(:new_order_forward_buyer) do |order| # rubocop:disable RSpec/MessageSpies
          expect(order.buyer).to eq(buyer)
          expect(order.order_items.first.ebook).to eq(ebook)
          buyer_mailer
        end

        expect(OrderMailer).to receive(:new_order_forward_seller) do |order_item| # rubocop:disable RSpec/MessageSpies
          expect(order_item.ebook).to eq(ebook)
          expect(order_item.ebook.seller).to eq(seller)
          seller_mailer
        end

        order
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
