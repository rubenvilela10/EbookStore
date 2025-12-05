class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :ebook

  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :fee, numericality: { greater_than_or_equal_to: 0 }

  before_validation :assign_price_and_fee

  private

  def assign_price_and_fee
    return unless ebook

    self.price ||= ebook.price
    self.fee   ||= ebook.price * 0.10
  end
end
