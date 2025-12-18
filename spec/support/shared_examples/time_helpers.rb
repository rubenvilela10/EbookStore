RSpec.shared_examples "a model with timestamps" do
  it "has a timestamps attributes" do
    expect(subject).to respond_to(:created_at, :updated_at)
  end
end
