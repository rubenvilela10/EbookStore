class User < ApplicationRecord
    ROLES = %w[buyer seller admin].freeze
    STATUSES = %w[enabled disabled].freeze

    has_many :ebooks, foreign_key: "seller_id", dependent: :nullify
    has_many :orders, foreign_key: "buyer_id", dependent: :nullify
    has_many :order_items, through: :orders

    has_one_attached :profile_pic
    validates :name, presence: true

    scope :admin, -> { where(role: "admin") }
    scope :seller, -> { where(role: "seller") }
    scope :buyer, -> { where(role: "buyer") }
end
