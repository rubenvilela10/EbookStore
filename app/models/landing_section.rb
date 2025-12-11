class LandingSection < ApplicationRecord
  belongs_to :landing_page

  has_one_attached :landing_image
end
