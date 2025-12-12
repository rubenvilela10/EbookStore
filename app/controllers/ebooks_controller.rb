class EbooksController < ApplicationController
  before_action :set_ebook, only: :show
  def index
    @ebooks = Ebook.all

    if params[:min_price].present?
      @ebooks = @ebooks.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      @ebooks = @ebooks.where("price <= ?", params[:max_price])
    end

    if params[:author].present?
      @ebooks = @ebooks.where(author: params[:author])
    end

    if params[:seller_id].present?
      @ebooks = @ebooks.where(seller_id: params[:seller_id])
    end

    if params[:year].present?
      @ebooks = @ebooks.where(year: params[:year])
    end

    if params[:tag].present?
      @ebooks = @ebooks.joins(:tags).where(tags: { name: params[:tag] })
    end
  end

  def show
    EbookMetric.create!(
      ebook_id: @ebook.id,
      event_type: "view_ebook",
      ip: request.remote_ip,
      user_agent: request.user_agent,
      extra_data: { user: { id: current_user&.id } }
    )

    stat = EbookStat.find_or_create_by!(ebook_id: @ebook.id)
    stat.increment!(:views_count)
  end

  def search
    @query = params[:q]

    # left join - returns all ebooks and ebooks with tags
    # join returns ebook with tags
    # right join return all tags and ebooks with tags
    @ebooks = Ebook.left_joins(:tags)


    if params[:q].present?
      query = "%#{params[:q].downcase}%"

      @ebooks = @ebooks.where(
        "LOWER(ebooks.title) LIKE :q OR LOWER(ebooks.description) LIKE :q OR LOWER(ebooks.author) LIKE :q OR LOWER(tags.name) LIKE :q",
        q: query
      ).distinct
    end

    render :index
  end

  def download_draft
    set_ebook

    unless @ebook.pdf_draft.attached?
      redirect_to @ebook, notice: "No pdf available for download!"
    end

    EbookMetric.create!(
      ebook_id: @ebook.id,
      event_type: "view_pdf",
      ip: request.remote_ip,
      user_agent: request.user_agent,
      extra_data: { user: { id: current_user&.id } }
    )

    stat = EbookStat.find_or_create_by!(ebook_id: @ebook.id)
    stat.increment!(:downloads_count)

    send_data(
      @ebook.pdf_draft.download,
      filename: "#{@ebook.title.parameterize}.pdf",
      type: "application/pdf",
      disposition: "attachment"
    )
  end

  private

  def set_ebook
    @ebook = Ebook.find(params[:id])
  end
end
