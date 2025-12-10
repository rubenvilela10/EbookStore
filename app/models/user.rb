class User < ApplicationRecord
    ROLES     = %w[buyer seller admin].freeze
    STATUSES  = %w[enabled disabled].freeze
    VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

    has_many :ebooks, foreign_key: "seller_id", dependent: :nullify
    has_many :orders, foreign_key: "buyer_id", dependent: :nullify
    has_many :order_items, through: :orders

    has_one_attached :profile_pic

    before_save { self.email = email.downcase }

    validates :name, presence: true
    validates :email,
              presence: true,
              uniqueness: { case_sensitive: false },
              length: { maximum: 105 },
              format: { with: VALID_EMAIL_REGEX }

    has_secure_password

    scope :admin,  -> { where(role: "admin") }
    scope :seller, -> { where(role: "seller") }
    scope :buyer,  -> { where(role: "buyer") }
end
