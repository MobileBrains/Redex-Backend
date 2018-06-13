class ManagementReportsController < ApplicationController
  before_action :set_management_report, only: [:show, :edit, :update, :destroy]

  # GET /management_reports
  # GET /management_reports.json
  def index()
    if current_user.is_a?(User)
      if current_user.has_role? :Admin
        @management_reports = ManagementReport.all
      end
      if current_user.has_role? :Auditor
        @management_reports = ManagementReport.where(client_id: current_user.client_id).all
      else

      end
    end
  end

  # GET /management_reports/1
  # GET /management_reports/1.json
  def show
  end

  # GET /management_reports/new
  def new
    @management_report = ManagementReport.new
  end

  # GET /management_reports/1/edit
  def edit
  end

  # POST /management_reports
  # POST /management_reports.json
  def create
    @management_report = ManagementReport.new(management_report_params)

    respond_to do |format|
      if @management_report.save
        format.html { redirect_to @management_report, notice: 'Management report was successfully created.' }
        format.json { render :show, status: :created, location: @management_report }
      else
        format.html { render :new }
        format.json { render json: @management_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /management_reports/1
  # PATCH/PUT /management_reports/1.json
  def update
    respond_to do |format|
      if @management_report.update(management_report_params)
        format.html { redirect_to @management_report, notice: 'Management report was successfully updated.' }
        format.json { render :show, status: :ok, location: @management_report }
      else
        format.html { render :edit }
        format.json { render json: @management_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /management_reports/1
  # DELETE /management_reports/1.json
  def destroy
    @management_report.destroy
    respond_to do |format|
      format.html { redirect_to management_reports_url, notice: 'Management report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_management_report
      @management_report = ManagementReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def management_report_params
      params.require(:management_report).permit(:name, :link, :description, :user_id, :client_id)
    end
end
