class Order < ApplicationRecord
  STATUSES = %w[paid cancelled].freeze

  belongs_to :buyer, class_name: "User"

  has_many :order_items, dependent: :destroy
  has_many :ebooks, through: :order_items

  accepts_nested_attributes_for :order_items, allow_destroy: true

  validates :buyer, presence: true
  validates :payment_status, inclusion: { in: STATUSES }
  validates :destination_address, presence: true
  validates :billing_address, presence: true
end
