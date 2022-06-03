class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
         
  #ゲストユーザー情報を探し、存在しなければ作成
  def self.guest
    find_or_create_by!(email: 'guest@nelc.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.name = "Guest User"
    end
  end
end
