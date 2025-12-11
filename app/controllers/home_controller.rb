class HomeController < ApplicationController
  def index
    @landing_page = LandingPage.first
    @landing_sections = @landing_page.landing_sections
  end
end
