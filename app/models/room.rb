class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  has_many :messages, dependent: :destroy

  def is_valid? #相手が存在しないルームを表示しない
    users.active.count == 2
  end

  def users_except(user) #チャットの相手を探す
    users.where.not(id: user.id).first
  end

  def last_sent
    message_id = messages.pluck(:id).last
    Message.find_by(room_id: id, id: message_id)
  end

end
