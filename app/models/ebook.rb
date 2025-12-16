class Ebook < ApplicationRecord
    belongs_to :seller, class_name: "User"

    has_many :order_items, dependent: :destroy
    has_many :orders, through: :order_items
    has_many :ebook_metrics, dependent: :destroy
    has_one :ebook_stat, dependent: :destroy
    has_many :ebook_tags, dependent: :destroy
    has_many :tags, through: :ebook_tags

    attr_accessor :tag_list

    has_one_attached :pdf_draft
    has_one_attached :cover

    STATUSES = %w[draft pending live disabled].freeze

    validates :title, presence: true
    validates :status, presence: true, inclusion: { in: STATUSES }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :author, presence: true


    scope :live, -> { where(status: "live") }
    scope :drafts, -> { where(status: "draft") }
    scope :pending, -> { where(status: "pending") }
    scope :by_seller, ->(user) { where(seller: user) }
    after_save :assign_tags

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

    def publish!
        return if status == "live"
        update!(status: "live")
    end

    def submit_for_review!
        return if status == "draft"
        update!(status: "pending")
    end

    private

    def assign_tags
        return unless tag_list.present?

        names = tag_list.split(",").map(&:strip).reject(&:empty?)

        self.tags = names.map do |name|
          Tag.find_or_create_by(name: name.downcase)
        end
    end
end
