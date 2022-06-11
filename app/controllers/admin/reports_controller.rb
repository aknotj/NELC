class Admin::ReportsController < ApplicationController

  def index
    @reports = Report.page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @report_note = @report.note
  end

  def update
    @report = Report.find(params[:id])
    @report.update(report_params)
    redirect_to admin_report_path(@report)
  end

private
  def report_params
    params.require(:report).permit(:is_closed, :note)
  end
end
