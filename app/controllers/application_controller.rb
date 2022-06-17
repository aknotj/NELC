class ApplicationController < ActionController::Base
  around_action :user_time_zone, if: :user_time_zone_present?

  def after_sign_in_path_for(resource)
    if user_signed_in?
      home_path
    else
      admin_users_path
    end
  end
  
  private
  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def user_time_zone_present?
    current_user.try(:time_zone).present?
  end
end
