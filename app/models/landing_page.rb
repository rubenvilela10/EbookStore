class LandingPage < ApplicationRecord
  has_many :landing_sections, dependent: :destroy

  has_one_attached :banner
end
