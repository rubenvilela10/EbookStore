class Admin::LandingPagesController < Admin::AdminController
  before_action :authenticate_admin!
  before_action :set_landing_page, only: [ :show, :edit, :update, :destroy ]

  def index
    @landing_pages = LandingPage.all
  end

  def show
  end

  def new
    @landing_page = LandingPage.new
  end

  def create
    @landing_page = LandingPage.new(landing_page_params)

    if @landing_page.save
      redirect_to admin_landing_page_path(@landing_page), notice: "Landing Page created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @landing_page.update(landing_page_params)
      redirect_to admin_landing_page_path(@landing_page), notice: "Landing Page updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @landing_page.destroy
    redirect_to admin_landing_pages_path, notice: "Landing Page destroyed."
  end

  private

  def set_landing_page
    @landing_page = LandingPage.find(params[:id])
  end

  def landing_page_params
    params.require(:landing_page).permit(
      :title, :subtitle, :description, :published, :banner_image
    )
  end
end
