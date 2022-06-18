class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  enum gender: {male: 0, female: 1, other: 2}

  scope :active, -> { where(is_deactivated: :false)}

  has_one_attached :profile_image
  has_many :posts, ->{order('created_at desc')}, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, ->{order('created_at desc')}, dependent: :destroy
  has_many :entries
  has_many :rooms, through: :entries
  has_many :messages, dependent: :destroy
  has_many :reports
  has_many :active_notifications, class_name: "Notification", foreign_key: "sender_id"
  has_many :passive_notifications, class_name: "Notification", foreign_key: "recipient_id"

  validates :name, presence: true

  #ゲストユーザー情報を探し、存在しなければ作成
  def self.guest
    find_or_create_by!(email: 'guest@nelc.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.name = "Guest User"
    end
  end

  #profile imageがなければデフォルトを使い、画像サイズを任意のサイズに縮小する
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no-image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no-image.jpg', content_type: 'image/jpg')
    end
    profile_image.variant(resize_to_fill: [width, height]).processed
  end

  #friend follow関係
  def friends
    following & followers
  end

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end

  def followed_by?(user)
    followers.include?(user)
  end

  def is_friend_with?(user)
    following?(user) && followed_by?(user)
  end

  def has_room_with?(user)
    rooms = Entry.pluck(:room_id)
    Entry.find_by(user_id: user.id, room_id: rooms).present?
  end

  #検索
  def self.search_for(name, language, gender, content)
    user = User.where("name LIKE ?", "%"+name.to_s+"%").where("introduction LIKE ?", "%"+content.to_s+"%")
    scope :male, -> {where(gender: "male")}
    scope :female, -> {where(gender: "female")}
    scope :other, -> {where(gender: "other")}
    if language == "Japanese"
      if gender == "male"
        user.male.where(native_language: "Japanese")
      elsif gender == "female"
        user.female.where(native_language: "Japanese")
      elsif gender == "other"
        user.other.where(native_language: "Japanese")
      else
        user.where(native_language: "Japanese")
      end
    elsif language == "English"
      if gender == "male"
        user.male.where(native_language: "English")
      elsif gender == "female"
        user.female.where(native_language: "English")
      elsif gender == "other"
        user.other.where(native_language: "English")
      else
        user.where(native_language: "English")
      end
    elsif gender == "male"
        user.male
    elsif gender == "female"
        user.female
    elsif gender == "other"
        user.other
    else
      user
    end
  end

  #フォロー通知
  def create_notification_follow(current_user)
    #過去のフォロー通知がないか確認
    record = Notification.where(sender_id: current_user.id, recipient_id: id, action: "follow")
    unless record.present?
      notification = current_user.active_notifications.new(
        recipient_id: id,
        action: "follow"
        )
      notification.save if notification.valid?
    end
  end

  def deactivate
    update(is_deactivated: true)
    posts.update_all(is_deleted: true)
    comments.update_all(is_deleted: true)
    active_relationships.destroy_all
    passive_relationships.destroy_all
    bookmarks.destroy_all
    entries.destroy_all
    messages.destroy_all
    acitve_notifications.destroy_all
    passive_notifications.destroy_all
  end

  #ユーザーの投稿のカテゴリー一覧
  def post_categories
    post_ids = Post.where(user_id: id).ids
    category_ids = PostCategory.where(post_id: post_ids).pluck(:category_id)
    Category.where(id: category_ids)
  end

end
