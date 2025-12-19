require 'rails_helper'

RSpec.describe Ebook, type: :model do
  subject(:ebook) { build(:ebook) }

  it_behaves_like "a model with status"
  it_behaves_like "a model with timestamps"
  it_behaves_like "a publishable resource"

  describe "validations" do
    it "is valid with valid attributes" do
      expect(ebook).to be_valid
    end

    it "is invalid without a title" do
      ebook.title = nil
      expect(ebook).not_to be_valid
      expect(ebook.errors[:title]).to include("can't be blank")
    end

    it "is invalid with a negative price" do
      ebook.price = -1
      expect(ebook).not_to be_valid
      expect(ebook.errors[:price]).to include("must be greater than or equal to 0")
    end

    it "is invalid without an author" do
      ebook.author = nil
      expect(ebook).not_to be_valid
      expect(ebook.errors[:author]).to include("can't be blank")
    end

    it "must be one of the following status: draft, pending, live" do
      ebook.status = "N/A"
      expect(ebook).not_to be_valid
      expect(ebook.errors[:status]).to include("is not included in the list")
    end
  end

  describe "status scopes and transitions" do
    include_context "draft ebooks"
    include_context "pending ebooks"
    include_context "live ebooks"

    it "returns only live ebooks for .live scope" do
      draft_ebook = draft_ebooks.first
      live_ebook  = live_ebooks.first

      expect(described_class.live).to include(live_ebook)
      expect(described_class.live).not_to include(draft_ebook)
    end

    it "changes draft to pending" do
      draft = draft_ebooks.first
      draft.submit_for_review!
      expect(draft.status).to eq("pending")
    end

    it "changes pending to live" do
      pending = pending_ebooks.first
      pending.publish!
      expect(pending.status).to eq("live")
    end
  end

  describe "by seller" do
    it "returns ebooks from the correct seller" do
      s1 = create(:user, name: "Seller 1")
      s2 = create(:user, name: "Seller 2")

      ebook1 = create(:ebook, seller: s1)
      ebook2 = create(:ebook, seller: s2)

      expect(described_class.by_seller(s1)).to include(ebook1)
      expect(described_class.by_seller(s1)).not_to include(ebook2)
    end
  end

  describe "stats" do
    let(:ebook) { create(:ebook) }

    it "returns the number of ebooks purchased" do
      create_list(:order_item, 3, ebook: ebook)
      create(:order_item)

      expect(ebook.purchase_count).to eq(3)
    end

    it "returns the number of ebooks viewed" do
      create_list(:ebook_metric, 5, ebook: ebook, event_type: "view_ebook")
      expect(ebook.view_count).to eq(5)
    end

    it "returns the number of PDF views on a single ebook" do
      create_list(:ebook_metric, 3, ebook: ebook, event_type: "view_pdf")
      expect(ebook.view_pdf).to eq(3)
    end
  end
end
