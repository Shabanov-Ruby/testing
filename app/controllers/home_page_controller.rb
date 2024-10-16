# frozen_string_literal: true

class HomePageController < ApplicationController
  before_action :authenticate_user!
  before_action :set_users

  def index
    @my_posts = current_user.posts.order(created_at: :desc)
    @following_posts = current_user.following_posts
  end

  def set_users
    @users = User.where.not(id: current_user.id)
  end
end
