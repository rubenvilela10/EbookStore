class HomeController < ApplicationController
  def index
    @landing_page = LandingPage.first
    @landing_sections = @landing_page.landing_sections

    redirect_to admin_root_path if current_user&.admin?
  end
end
