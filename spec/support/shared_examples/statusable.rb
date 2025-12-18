RSpec.shared_examples "a model with status" do
  it "has a status attribute" do
    expect(subject).to respond_to(:status)
  end
end
