class Admin::LandingSectionsController < Admin::AdminController
  before_action :authenticate_admin!
  before_action :set_landing_page
  before_action :set_section, only: [ :edit, :update, :destroy ]

  def new
    @section = @landing_page.landing_sections.new
  end

  def create
    @section = @landing_page.landing_sections.new(section_params)

    if @section.save
      redirect_to admin_landing_page_path(@landing_page), notice: "Secção criada."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @section.update(section_params)
      redirect_to admin_landing_page_path(@landing_page), notice: "Secção atualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @section.destroy
    redirect_to admin_landing_page_path(@landing_page), notice: "Secção removida."
  end

  private

  def set_landing_page
    @landing_page = LandingPage.find(params[:landing_page_id])
  end

  def set_section
    @section = @landing_page.landing_sections.find(params[:id])
  end

  def section_params
    params.require(:landing_section).permit(
      :title, :subtitle, :content, :link, :position, :image
    )
  end
end
