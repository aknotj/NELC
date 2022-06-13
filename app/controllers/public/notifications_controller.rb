class Public::NotificationsController < ApplicationController

  def index
    @notifications = current_user.passive_notifications.all
  end

  def update
    @notification = Notification.find(params[:id]).update(is_checked: true)
    redirect_to notifications_path
  end

  def update_all
    current_user.passive_notifications.update_all(is_checked: true)
    redirect_to notifications_path
  end


end
