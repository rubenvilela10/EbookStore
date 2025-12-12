class EbooksController < ApplicationController
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
end
