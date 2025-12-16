require "rails_helper"

RSpec.describe Order, type: :model do
  include ActiveJob::TestHelper

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
