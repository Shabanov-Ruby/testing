# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  has_many :follower_relationships, class_name: 'Follow', dependent: :destroy, inverse_of: :user
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following_relationships, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy,
                                     inverse_of: :follower
  has_many :following, through: :following_relationships, source: :user
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  def not_me
    User.where.not(id:)
  end

  def following_posts
    following_ids = following.pluck(:id)
    Post.where(user_id: following_ids)
  end
end
