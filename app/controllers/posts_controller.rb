# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @post = current_user.posts.build(post_params)

    return redirect_to root_path, alert: 'Публикация не может быть пустой!' if @post.content.blank?

    if @post.save
      redirect_to root_path, notice: 'Публикация создана!'
    else
      render :index, status: :unprocessable_entity, alert: 'Публикация не создана!'
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to root_path, notice: 'Публикация обновлена!'
    else
      render :edit, alert: 'Публикация не обновлена!'
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    if @post.destroy
      redirect_to root_path, notice: 'Публикация удалена!'
    else
      redirect_to root_path, alert: 'Публикация не может быть удалена!'
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
