# frozen_string_literal: true

class Post < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper
  before_save :format_text
  belongs_to :user

  has_many :comments, dependent: :destroy
  validates :content, presence: { message: 'Публикация не может быть пустой!' },
                      length: { minimum: 5, maximum: 90,
                                too_short: 'Публикация должна быть не менее 5 символов!',
                                too_long: 'Публикация должна быть не более 90 символов!' }

  private

  def format_text
    self.content = content.gsub(/<.*?>/, '').gsub(/(.{1,20})/, "\\1\n")
  end
end
