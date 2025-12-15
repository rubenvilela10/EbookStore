require 'rails_helper'

RSpec.describe Ebook, type: :model do
  subject(:ebook) { build(:ebook) }

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
      subject.status = "N/A"

      expect(ebook).not_to be_valid
      expect(ebook.errors[:status]).to include("is not included in the list")
    end
  end

  describe 'live status' do
    it 'returns only live ebooks' do
      draft_ebook = create(:ebook, status: :draft)
      live_ebook  = create(:ebook, status: :live)

      expect(Ebook.live).to include(live_ebook)
      expect(Ebook.live).not_to include(draft_ebook)
    end
  end

  describe "by seller" do
    it "returns ebooks from a proper seller" do
      s1 = create(:user, name: "Seller 1")
      s2 = create(:user, name: "Seller 2")

      ebook1 = create(:ebook, seller: s1)
      ebook2 = create(:ebook, seller: s2)

      result = Ebook.by_seller(s1)


      expect(result).to include(ebook1)
      expect(result).not_to include(ebook2)
    end
  end
end
