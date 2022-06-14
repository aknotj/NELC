class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.all
  end

  def update
    @notification = Notification.find(params[:id]).update(is_checked: true)
  end

  def update_all
    current_user.passive_notifications.update_all(is_checked: true)
  end

end
