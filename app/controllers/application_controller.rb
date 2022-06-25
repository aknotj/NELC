class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    if user_signed_in?
      home_path
    else
      admin_reports_pending_path
    end
  end

end
