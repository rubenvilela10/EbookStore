require "rails_helper"

RSpec.describe "Ebook metrics tracking", type: :request do
  include_context "authenticate admin"
  include_context "ebook metrics setup"

  describe "ebook page view" do
    it_behaves_like "records ebook metric",
      event_type: "view_ebook",
      request: -> {
        get ebook_path(ebook),
          headers: { "User-Agent" => "Browser" },
          env: { "REMOTE_ADDR" => "8.8.8.8" }
      }
  end

  describe "ebook pdf download" do
    it_behaves_like "records ebook metric",
      event_type: "view_pdf",
      request: -> {
        get download_draft_ebook_path(ebook),
          headers: { "User-Agent" => "Browser" },
          env: { "REMOTE_ADDR" => "8.8.8.8" }
      }
  end
end
