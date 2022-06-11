class Public::ReportsController < ApplicationController

  def new
    @report = current_user.reports.new
  end

  def new_en
    @report = current_user.reports.new
  end

  def create
    @report = current_user.reports.new(report_params)
    unless @report.invalid?
      @report.save
      redirect_to report_path(@report)
    end
  end

  def show
    @report = Report.find(params[:id])
  end

  private

  def report_params
   params.require(:report).permit(:category, :detail, :model, :subject_id, :post_id)
  end

end
