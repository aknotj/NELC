class Public::NotificationsController < ApplicationController

  def index
    @notifications = current_user.passive_notifications.all
  end

  def update
    @notification = Notification.find(params[:id]).update(checked: true)
    redirect_to notifications_path
  end

  def update_all
  end
  
  
end
