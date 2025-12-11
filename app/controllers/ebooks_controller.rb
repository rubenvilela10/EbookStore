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
end
