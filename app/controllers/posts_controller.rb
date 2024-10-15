# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @post = current_user.posts.build(post_params)

    return redirect_to root_path, notice: 'Публикация не может быть пустой!' if @post.content.blank?

    if @post.save
      redirect_to root_path, notice: 'Публикация создана!'
    else
      redirect_to root_path, notice: 'Публикация не может быть создана ограничение на 90 символов!'
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
    @initial_content = @post.content
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.content == post_params[:content]
      flash[:notice] = 'Ничего не изменено. Пожалуйста, внесите изменения.'
      render :edit
    elsif @post.update(post_params)
      flash[:notice] = 'Публикация обновлена!' if @post.saved_changes?
      redirect_to root_path
    else
      flash[:alert] = 'Публикацию не удалось обновить.'
      render :edit
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    if @post.destroy
      redirect_to root_path, notice: 'Публикация удалена!'
    else
      redirect_to root_path, notice: 'Публикация не может быть удалена!'
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
