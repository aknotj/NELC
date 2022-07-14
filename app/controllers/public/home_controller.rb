class Public::HomeController < ApplicationController
  around_action :user_time_zone, if: :user_time_zone_present?
  before_action :authenticate_user!, only: [:home]

  def top
  end

  def home
    @posts = Post.published.where(user_id: [current_user.id, *current_user.following_ids])
                            .includes(user: {profile_image_attachment: :blob})
                            .page(params[:page])
    @time = Time.zone.now
  end
  
  private
  
  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def user_time_zone_present?
    current_user.try(:time_zone).present?
  end
end
