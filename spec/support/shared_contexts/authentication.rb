RSpec.shared_context "authenticate admin", :authenticate_admin do
  let(:current_user) { create(:user, :admin) }

  # mock - is this right?
  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(current_user)
  end
end

RSpec.shared_context "authenticate seller", :authenticate_seller do
  let(:current_user) { create(:user, :seller) }

  # mock - is this right?
  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(current_user)
  end
end
