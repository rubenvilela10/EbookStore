require "rails_helper"

RSpec.describe "Ebook metrics tracking", type: :request do
  let(:user)  { create(:user, password: "123456") }
  let(:ebook) { create(:ebook) }

  before do
    post login_path, params: { email: user.email, password: "123456" }

    allow(EbookStat).to receive(:find_or_create_by!)
      .and_return(instance_double(EbookStat, increment!: true))

    allow(EbookMetric).to receive(:create!)

    ebook.pdf_draft.attach(
      io: StringIO.new("dummy content"),
      filename: "dummy.pdf",
      content_type: "application/pdf"
    )
  end

  it "records view metric with correct data" do
    expect(EbookMetric).to receive(:create!).with(
      hash_including(
        ebook_id: ebook.id,
        event_type: "view_ebook",
        ip: "8.8.8.8",
        user_agent: "Browser",
        extra_data: {
          user: { id: user.id }
        }
      )
    )

    get ebook_path(ebook),
        headers: { "User-Agent" => "Browser" },
        env: { "REMOTE_ADDR" => "8.8.8.8" }
  end

  it "record pdf download tracking" do
    expect(EbookMetric).to receive(:create!).with(
      hash_including(
        ebook_id: ebook.id,
        event_type: "view_pdf",
        ip: "8.8.8.8",
        user_agent: "Browser",
        extra_data: {
          user: { id: user.id }
        }
      )
    )

    get download_draft_ebook_path(ebook),
      headers: { "User-Agent" => "Browser" },
      env: { "REMOTE_ADDR" => "8.8.8.8" }
  end
end
