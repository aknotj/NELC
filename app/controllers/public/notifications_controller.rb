class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @notifications = current_user.passive_notifications
                                  .includes(:comment,
                                            :post,
                                            :user,
                                            sender: {profile_image_attachment: :blob})
                                  .all
    @notifications.where(is_checked: false).each do |notification|
      notification.update(is_checked: true)
    end
  end

  def destroy
    @notification = Notification.find(params[:id]).destroy
    @notifications = current_user.passive_notifications
                                  .includes(:comment,
                                            :post,
                                            :user,
                                            sender: {profile_image_attachment: :blob})
                                  .all
    render "destroy"
  end

  def destroy_all
    current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
