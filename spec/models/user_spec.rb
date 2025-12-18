require "rails_helper"

RSpec.describe User, type: :model do
  include ActiveJob::TestHelper

  subject(:user) { build(:user) }
  it_behaves_like "a model with status"
  it_behaves_like "a model with timestamps"

  describe "validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user.name = nil

      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an email" do
      user.email = nil

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with an invalid email format" do
      user.email = "invalid-email"

      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "does not allow duplicate emails" do
      create(:user, email: user.email)

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "downcases the email address before validation" do
      created_user = create(:user, email: "TEST@EMAIL.COM")

      expect(created_user.email).to eq("test@email.com")
    end

    it "is invalid without a password" do
      user.password = nil

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end
  end

  describe "status methods" do
    it "disables the user" do
      user = create(:user, :enabled)

      user.disable!

      expect(user).to be_disabled
    end

    it "returns true when user is enabled" do
      user = create(:user, :enabled)

      expect(user).to be_enabled
    end

    it "enables the user" do
      user = create(:user, :disabled)

      user.enable!

      expect(user).to be_enabled
    end

    it "returns true when user is disabled" do
      user = create(:user, :disabled)

      expect(user).to be_disabled
    end
  end

  describe "after commit callbacks" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it "sends welcome email to user on create" do
      expect do
        perform_enqueued_jobs do
          create(:user, :enabled, :seller)
        end
      end.to change { ActionMailer::Base.deliveries.count }.by(1)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include(User.last.email)
    end
  end
end
