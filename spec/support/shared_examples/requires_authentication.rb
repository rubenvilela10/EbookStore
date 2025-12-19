RSpec.shared_examples "requires authentication" do
  it "requires login when not authenticated" do
    expect(response).to redirect_to(login_path)
    expect(flash[:alert]).to eq("Please login!")
  end
end
