# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user.not_me.find_by(id: params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def follow
    current_user.following_relationships.create(user_id: params[:id])
    redirect_to user_path(params[:id]), notice: 'Вы подписались!'
  end

  def unfollow
    current_user.following_relationships.find_by(user_id: params[:id]).destroy
    redirect_to user_path(params[:id]), notice: 'Вы отписались!'
  end
end
