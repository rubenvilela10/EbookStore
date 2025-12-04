class EbookMetric < ApplicationRecord
  EVENT_TYPES = %w[view_ebook view_draft purchase].freeze

  belongs_to :ebook

  validates :event_type, presence: true, inclusion: { in: EVENT_TYPES }

  serialize :extra_data, JSON
end