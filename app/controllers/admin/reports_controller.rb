class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @reports = Report.includes(:user, :post, :comment, :subject_user).page(params[:page])
  end

  def pending
    @reports = Report.pending.includes(:user, :post, :comment, :subject_user).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    @report.update(report_params)
    redirect_to request.referer
    flash[:notice] = "The report has been successfully updated"
  end

  private
  def report_params
    params.require(:report).permit(:is_closed, :note)
  end
end
