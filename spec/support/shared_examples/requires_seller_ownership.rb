RSpec.shared_examples "requires seller ownership" do
  it "requires current_user to be seller" do
    expect(response).to redirect_to(login_path)
  end
end
