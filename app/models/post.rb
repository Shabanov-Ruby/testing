# frozen_string_literal: true

class Post < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper
  before_save :format_text
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :content, presence: true, length: { minimum: 1, maximum: 90 }
  private

  def format_text
    self.content = content.gsub(/<.*?>/,'').gsub(/(.{1,20})/, "\\1\n")
  end
end
