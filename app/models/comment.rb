# frozen_string_literal: true

class Comment < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper
  before_save :format_text
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy, inverse_of: :parent

  validates :content, presence: true, length: { minimum: 1, maximum: 70 }

  def level
    parent_id.nil? ? 0 : parent.level + 1
  end
  private

  def format_text
    self.content = content.gsub(/<.*?>/,'').gsub(/(.{1,20})/, "\\1\n")
  end
end
