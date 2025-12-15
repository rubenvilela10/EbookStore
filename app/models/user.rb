class User < ApplicationRecord
    ROLES     = %w[buyer seller admin].freeze
    STATUSES  = %w[enabled disabled].freeze
    VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

    has_many :ebooks, foreign_key: "seller_id", dependent: :nullify
    has_many :orders, foreign_key: "buyer_id", dependent: :nullify
    has_many :order_items, through: :orders

    has_one_attached :profile_pic

    before_save { self.email = email.downcase }
    before_save :set_password_changed_at, if: :will_save_change_to_password_digest?

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

    def admin?
        role == "admin"
    end

    def seller?
        role == "seller"
    end

    def buyer?
        role == "buyer"
    end

    def enable!
        return if enabled?
        update!(status: "enabled")
    end

    def disable!
        return if disabled?
        update!(status: "disabled")
    end

    def enabled?
        status == "enabled"
    end

    def disabled?
        status == "disabled"
    end

    private

    def set_password_changed_at
        self.password_changed_at = Time.current
    end
end
