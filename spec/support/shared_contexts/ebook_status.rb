RSpec.shared_context "draft ebooks" do
  let(:seller) { create(:user) }
  let!(:draft_ebooks) { create_list(:ebook, 5, :draft, seller: seller) }
end

RSpec.shared_context "pending ebooks" do
  let(:seller) { create(:user) }
  let!(:pending_ebooks) { create_list(:ebook, 5, :pending, seller: seller) }
end

RSpec.shared_context "live ebooks" do
  let(:seller) { create(:user) }
  let!(:live_ebooks) { create_list(:ebook, 5, :live, seller: seller) }
end
