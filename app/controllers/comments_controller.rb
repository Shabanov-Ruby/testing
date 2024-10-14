# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.create(comment_params.merge(user: current_user))
    redirect_back(fallback_location: root_path)
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to posts_path, notice: 'Комментарий успешно обновлен.'
    else
      render :edit, alert: 'Комментарий не удалось обновить.'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.user == current_user
      delete_sub_comments(@comment)
      @comment.destroy
      flash[:notice] = 'Комментарий успешно удален.'
    else
      flash[:alert] = 'У вас нет прав на удаление этого комментария.'
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def delete_sub_comments(comment)
    comment.replies.each do |child|
      delete_sub_comments(child)
      child.destroy
    end
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
