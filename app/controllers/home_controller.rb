class HomeController < ApplicationController
  def index
    @page = LandingPage.first
    @sections = @page&.sections&.order(:position)

    redirect_to admin_path if current_user&.admin?
  end
end
