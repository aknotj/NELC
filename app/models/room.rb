class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def users_except(user) #チャットの相手を探す
    users.where.not(id: user.id).first
  end

  def last_sent
    message_id = messages.pluck(:id).last
    Message.find_by(room_id: id, id: message_id)
  end

  def unchecked_notifications(current_user)
    current_user.passive_notifications.where(room_id: id).where(is_checked: false)
  end

end
