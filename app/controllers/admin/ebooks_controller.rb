class Admin::EbooksController < Admin::AdminController
  before_action :authenticate_admin!
  before_action :set_ebook, only: %i[ show edit update destroy ]

  layout "admin"

  def index
    @ebooks = Ebook.all
  end

  def show
  end

  def new
    @ebook = Ebook.new
    @sellers = User.seller.order(:name)
  end

  def edit
    @sellers = User.seller.order(:name)
  end

  def create
    @ebook = Ebook.new(ebook_params)

    respond_to do |format|
      if @ebook.save
        redirect_to admin_ebook_path(@ebook), notice: "Ebook was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update
    respond_to do |format|
      if @ebook.update(ebook_params)
        redirect_to admin_ebook_path(@ebook), notice: "Ebook was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @ebook.destroy!

    respond_to do |format|
      format.html { redirect_to ebooks_path, notice: "Ebook was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_ebook
    @ebook = Ebook.find(params[:id])
  end

  def ebook_params
    params.require(:ebook).permit(
      :title, :description, :price, :status, :author, :year, :seller_id, :pdf_draft, :cover, :tag_list
    )
  end
end
