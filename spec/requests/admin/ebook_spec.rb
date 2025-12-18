require 'rails_helper'

RSpec.describe "Admin::Ebooks", type: :request do
  describe "GET #edit" do
    context "no user logged in" do
      let(:ebook) { build(:ebook) }

      before do
        get edit_admin_ebook_path(:ebook)
      end

      it_behaves_like "requires authentication"
    end

    context "no admin user logged in" do
      let(:ebook) { build(:ebook) }
      include_context "authenticate seller"

      before do
        get edit_admin_ebook_path(:ebook)
      end

      it_behaves_like "requires admin role"
    end
  end
end

RSpec.describe "Admin::Ebooks", type: :request, authenticate_admin: true do
  let(:ebook) { create(:ebook) }

  describe "GET #edit" do
    it "renders the edit page successfully" do
      get edit_admin_ebook_path(ebook)
      expect(response).to have_http_status(:success)
    end
  end
end

RSpec.describe "Admin::Ebooks", type: :request, authenticate_seller: true do
  let(:ebook) { create(:ebook) }

  describe "GET #edit" do
    it "redirects non-admin seller to root" do
      get edit_admin_ebook_path(ebook)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Access Denied!")
    end
  end
end
