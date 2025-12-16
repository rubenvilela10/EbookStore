require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a name" do
      subject.name = nil

      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an email" do
      subject.email = nil

      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it "does not allow duplicate emails" do
      create(:user, email: subject.email)

      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("has already been taken")
    end

    it "downcases the email address" do
      user = create(:user, email: "TEST@EMAIL.COM")

      expect(user.email).to eq("test@email.com")
    end
  end

  describe "status methods" do
    it "should disable user" do
      user = FactoryBot.create(:user)
      user.disable!

      expect(user.status).to eq("disabled")
    end

    it "should return true when user is enabled" do
      user = FactoryBot.create(:user)

      expect(user.enabled?).to be true
    end

    it "should enable user" do
      user = FactoryBot.create(:user, status: "disabled")
      user.enable!

      expect(user.status).to eq("enabled")
    end

    it "should return true when user is disable" do
      user = FactoryBot.create(:user, status: "disabled")

      expect(user.disabled?).to be true
    end
  end

  include ActiveJob::TestHelper
  describe "after commit" do
    describe "send notifications" do
      before do
        ActionMailer::Base.deliveries.clear
      end

      it "sends welcome email to user on create" do
        expect do
          perform_enqueued_jobs do
            create(:user)
          end
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
