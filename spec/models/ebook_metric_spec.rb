require "rails_helper"

RSpec.describe "Ebook metrics", type: :model do
  subject(:ebook_metric) { build(:ebook_metric) }
  it_behaves_like "a model with timestamps"

  describe "validations" do
    it "is valid with valid attributes" do
      expect(ebook_metric).to be_valid
    end


    it "valids event type" do
      subject.event_type = "N/A"

      expect(ebook_metric).not_to be_valid
      expect(ebook_metric.errors[:event_type]).to include("is not included in the list")
    end

    it "must be one of the following event_type: view_pdf, view_ebook, purchase" do
      [ "purchase", "view_ebook", "view_pfd" ].each do |type|
        subject.event_type = type
        expect(ebook_metric.event_type).to eq(type)
      end
    end
  end
end
