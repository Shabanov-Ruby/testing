class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
end
