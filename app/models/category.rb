class Category < ApplicationRecord
  has_many :post_categories, dependent: :destroy
  has_many :posts, through: :post_categories

  validates :name, presence: true, length:{maximum: 50}

  #登録post数が多い順番に表示
  def self.order_by_posts
    Category.joins(post_categories: :post).group('category_id').order('count(post_id) desc')
  end

  def self.tagged_by(user)
    posts = user.posts.published.select(:id)
    categories = PostCategory.where(post_id: posts).pluck(:category_id)
    Category.where(id: categories).includes(:posts)
  end

end
