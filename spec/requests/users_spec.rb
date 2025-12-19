require 'rails_helper'

RSpec.describe User, type: :request do
  subject { build(:user) }

  describe "find user stub" do
    it "returns the user" do
      allow(described_class).to receive(:find).with(1).and_return(:user)

      result = described_class.find(1)

      expect(result).to eq(:user)
    end
  end
end
