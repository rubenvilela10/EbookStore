RSpec.shared_context "when draft ebooks" do
  let(:seller) { create(:user) }
  let(:draft_ebooks) { create_list(:ebook, 5, :draft, seller: seller) }
end

RSpec.shared_context "when pending ebooks" do
  let(:seller) { create(:user) }
  let(:pending_ebooks) { create_list(:ebook, 5, :pending, seller: seller) }
end

RSpec.shared_context "when live ebooks" do
  let(:seller) { create(:user) }
  let(:live_ebooks) { create_list(:ebook, 5, :live, seller: seller) }
end
