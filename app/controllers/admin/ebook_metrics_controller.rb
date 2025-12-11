class Admin::EbookMetricsController < Admin::AdminController
  before_action :authenticate_admin!
  before_action :set_ebook_metric, only: %i[ show edit update destroy ]

  layout "admin"

  def index
    @ebook_metrics = EbookMetric.all
  end

  def show
  end

  def new
    @ebook_metric = EbookMetric.new
  end

  def edit
  end

  def create
    @ebook_metric = EbookMetric.new(ebook_metric_params)

    respond_to do |format|
      if @ebook_metric.save
        format.html { redirect_to @ebook_metric, notice: "Ebook metric was successfully created." }
        format.json { render :show, status: :created, location: @ebook_metric }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ebook_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @ebook_metric.update(ebook_metric_params)
        format.html { redirect_to @ebook_metric, notice: "Ebook metric was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @ebook_metric }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ebook_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ebook_metric.destroy!

    respond_to do |format|
      format.html { redirect_to ebook_metrics_path, notice: "Ebook metric was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_ebook_metric
      @ebook_metric = EbookMetric.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ebook_metric_params
      params.require(:ebook_metric).permit(
      )
    end
end
