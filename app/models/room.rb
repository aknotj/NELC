class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  has_many :messages, dependent: :destroy

  def users_except(user) #チャットの相手を
    users.where.not(id: user.id).first
  end

end
