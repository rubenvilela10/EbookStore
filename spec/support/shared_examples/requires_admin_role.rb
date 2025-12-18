# spec/support/shared_examples/requires_authentication.rb
RSpec.shared_examples "requires admin role" do
  it "denies acccess when user is not an admin" do
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq("Access Denied!")
  end
end
