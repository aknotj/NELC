class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  has_many :messages, dependent: :destroy

  def is_valid? #相手が存在しないルームを表示しない
    users.count == 2
  end

  def users_except(user) #チャットの相手を探す
    users.where.not(id: user.id).first
  end

end
