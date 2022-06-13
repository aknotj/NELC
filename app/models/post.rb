class Post < ApplicationRecord
  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
  has_many :comments, ->{order('created_at desc')}, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  scope :published, -> { where(is_deleted: false) }

  default_scope -> {order('posts.id desc')}
  validates :user_id, presence: true
  validates :title, presence: true, length: {maximum: 50}
  validates :body, presence: true, length: {maximum: 300}

  enum language: {english: 0, japanese: 1, other: 2}


  #カテゴリー保存
  def save_categories(entered_categories)
    current_categories = self.categories.pluck(:name) unless self.categories.nil?
    old_categories = current_categories - entered_categories
    add_categories = entered_categories - current_categories

    old_categories.each do |old_name|
      self.categories.delete Category.find_by(name:old_name)
    end

    add_categories.each do |category|
      post_category = Category.find_or_create_by(name:category)
      self.categories << post_category
    end
  end

  #post showページネーション
  def previous
    Post.published.where(user_id: self.user_id).where("id < ?", self.id).order("id DESC").first
  end

  def next
    Post.published.where(user_id: self.user_id).where("id > ?", self.id).order("id ASC").first
  end

  def bookmarked_by?(user)
    bookmarks.find_by(user_id: user.id).present?
  end

  #検索
  def self.search_for(language, content)
    posts = Post.published.where("title LIKE ?", "%"+content.to_s+"%").or(Post.published.where("body LIKE ?", "%"+content.to_s+"%"))
    if language == "japanese"
      posts.where(language: "japanese")
    elsif language == "english"
      posts.where(language: "english")
    elsif language == "other"
      posts.where(language: "other")
    else
      posts
    end
  end

  #コメント通知
  def create_notification_comment(current_user, comment_id)
    unless user_id == current_user.id
      notification = current_user.active_notifications.new(
        recipient_id: user_id,
        post_id: id,
        comment_id: comment_id,
        action: "comment"
        )
      notification.save if notification.valid?
    end
  end

end
