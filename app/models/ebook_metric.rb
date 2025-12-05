class EbookMetric < ApplicationRecord
  belongs_to :ebook

  EVENT_TYPES = %w[view_ebook view_draft purchase].freeze

  validates :event_type, presence: true, inclusion: { in: EVENT_TYPES }
end