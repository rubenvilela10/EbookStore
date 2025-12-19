require 'rails_helper'

RSpec.describe "Admin::Ebooks", type: :request do # rubocop:disable RSpec/MultipleDescribes
  describe "GET #edit" do
    context "when no user logged in" do
      let(:ebook) { build(:ebook) }

      before do
        get edit_admin_ebook_path(:ebook)
      end

      it_behaves_like "requires authentication"
    end

    context "when no admin user logged in" do
      let(:ebook) { build(:ebook) }

      include_context "when authenticate seller"

      before do
        get edit_admin_ebook_path(:ebook)
      end

      it_behaves_like "requires admin role"
    end
  end
end

RSpec.describe "Admin::Ebooks", :authenticate_admin, type: :request do
  let(:ebook) { create(:ebook) }

  describe "GET #edit" do
    it "renders the edit page successfully" do
      get edit_admin_ebook_path(ebook)
      expect(response).to have_http_status(:success)
    end
  end
end

RSpec.describe "Admin::Ebooks", :authenticate_seller, type: :request do
  let(:ebook) { create(:ebook) }

  describe "GET #edit" do
    it "redirects non-admin seller to root" do # rubocop:disable RSpec/MultipleExpectations
      get edit_admin_ebook_path(ebook)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Access Denied!")
    end
  end
end
