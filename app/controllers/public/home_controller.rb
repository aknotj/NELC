class Public::HomeController < ApplicationController
  before_action :authenticate_user!, only: [:home]

  def top
  end

  def home
    @posts = Post.published.where(user_id: [current_user.id, *current_user.following_ids])
                            .includes(user: {profile_image_attachment: :blob})
                            .page(params[:page])
    @time = Time.zone.now
  end
end
