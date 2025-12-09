class Admin::AdminController < ApplicationController
  before_action :authenticate_admin

  layout "admin"

  def index
    @ebooks_count = Ebook.count
    @orders = Order.count
    @total_views = EbookStat.sum(:views_count)
    @total_downloads = EbookStat.sum(:downloads_count)
    @total_revenue = Order.sum(:total_price)
    @total_fee = Order.sum(:total_fee)

    @top_ebooks_sold = Ebook
      .joins(:ebook_stat)
      .order(Arel.sql("ebook_stats.purchases_count DESC"))
      .limit(5)

    @top_ebooks_viewed = Ebook
      .joins(:ebook_stat)
      .order(Arel.sql("ebook_stats.views_count DESC"))
      .limit(5)

    @recent_events = EbookMetric.order(created_at: :desc).limit(10)
    @unique_visitors =  EbookMetric.select(:ip).distinct.count
  end
end
