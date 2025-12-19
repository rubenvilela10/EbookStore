RSpec.shared_context "ebook metrics setup" do
  let(:ebook) { create(:ebook) }

  before do
    allow(EbookStat).to receive(:find_or_create_by!)
      .and_return(instance_double(EbookStat, increment!: true))

    allow(EbookMetric).to receive(:create!)

    ebook.pdf_draft.attach(
      io: StringIO.new("dummy content"),
      filename: "dummy.pdf",
      content_type: "application/pdf"
    )
  end
end
