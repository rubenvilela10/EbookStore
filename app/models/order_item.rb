class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :ebook

  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :fee, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_fee, if: -> { fee.blank? && price.present? }

  private

  def set_fee
    self.fee = (price * 0.10).round(2)
  end
end