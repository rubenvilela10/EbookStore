RSpec.shared_context "authenticate user" do
  let(:current_user) { create(:user) }

  before do
    login(current_user)
  end
end

RSpec.shared_context "authenticated seller" do
  let(:current_user) { create(:user, :seller) }
  let!(:seller_ebooks) { create_list(:ebook, 3, seller: current_user) }

  before do
    login(current_user)
  end
end
