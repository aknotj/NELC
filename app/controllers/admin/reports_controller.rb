class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @reports = Report.page(params[:page])
  end
  
  def pending
    @reports = Report.pending.page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @report_note = @report.note
  end

  def update
    @report = Report.find(params[:id])
    @report.update(report_params)
    redirect_to admin_report_path(@report)
    flash[:notice] = "The report has been successfully updated"
  end

private
  def report_params
    params.require(:report).permit(:is_closed, :note)
  end
end
