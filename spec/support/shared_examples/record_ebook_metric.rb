RSpec.shared_examples "records ebook metric" do |event_type:, request:|
  it "records #{event_type} metric with correct data" do # rubocop:disable RSpec/ExampleLength
    expect(EbookMetric).to receive(:create!).with( # rubocop:disable RSpec/MessageSpies
      hash_including(
        ebook_id: ebook.id,
        event_type: event_type,
        ip: "8.8.8.8",
        user_agent: "Browser",
        extra_data: {
          user: { id: current_user.id }
        }
      )
    )

    instance_exec(&request)
  end
end
