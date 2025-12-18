RSpec.shared_examples "requires authentication" do
  it "requires to login when not authenticated" do
    expect(response).to redirect_to(login_path)
  end
end
