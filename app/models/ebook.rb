class Ebook < ApplicationRecord
    belongs_to :seller, class_name: "User"

    has_many :order_items, dependent: :destroy
    has_many :orders, through: :order_items
    has_many :ebook_metrics, dependent: :destroy

    has_one_attached :pdf_draft
    
    STATUSES = %w[draft pending live disabled].freeze

    validates :title, presence: true
    validates :status, presence: true, inclusion: { in: STATUSES }
    validates :price, presence: true, numericality: { greather_than_or_equal_to: 0 }


    scope :live, -> { where(status: "live") }
    scope :drafts, -> { where(status: "draft") }
    scope :pending, -> { where(status: "pending") }

    def purchase_count
        order_items.count
    end

    def view_count
        ebook_metrics.where(event_type: "view_ebook").count
    end

    def view_pdf
        ebook_metrics.where(event_type: "view_pdf").count
    end

    def total_revenue
        order_items.sum(:price)
    end
  end