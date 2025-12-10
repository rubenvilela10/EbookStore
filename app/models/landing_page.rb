class LandingPage < ApplicationRecord
  has_many :landing_sections

  has_one_attached :banner
end
