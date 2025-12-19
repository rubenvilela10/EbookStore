RSpec.shared_examples "requires authentication" do
  it "requires login when not authenticated" do # rubocop:disable RSpec/MultipleExpectations
    expect(response).to redirect_to(login_path)
    expect(flash[:alert]).to eq("Please login!")
  end
end
