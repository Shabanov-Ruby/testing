# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @post = current_user.posts.create!(post_params)
    redirect_to root_path, notice: 'Публикация создана!'
  end

  def edit
    @post = current_user.posts.find(params[:id])
    @initial_content = @post.content
  end

  def update
    @post = current_user.posts.find(params[:id])
    @post.update!(post_params)
    redirect_to root_path, notice: 'Публикация обновлена!'
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to root_path, notice: 'Публикация удалена!'
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
