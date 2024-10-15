# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @comment.comments.create(comment_params.merge(user: current_user))
    redirect_back(fallback_location: root_path)
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.user == current_user
      delete_sub_comments(@comment)
      @comment.destroy
      flash[:notice] = 'Комментарий успешно удален.'
    end

    redirect_back(fallback_location: root_path)
  end

#  def update
#    @comment = Comment.find(params[:id])
#    if @comment.update(comment_params)
#      flash[:notice] = 'Комментарий обновлен.' if @comment.saved_changes?
#      redirect_to posts_path
#    else
#      redirect_to edit_post_comment_path(@comment), notice: 'Комментарий не удалось обновить.'
#    end
#  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.content == comment_params[:content]
      flash[:notice] = 'Ничего не изменено. Пожалуйста, внесите изменения.'
      render :edit
    elsif @comment.update(comment_params)
      flash[:notice] = 'Комментарий обновлен!' if @comment.saved_changes?
      redirect_to root_path
    else
      flash[:notice] = 'Комментарий не удалось обновить.'
      render :edit
    end
  end


  private

  def delete_sub_comments(comment)
    comment.replies.each do |child|
      delete_sub_comments(child)
      child.destroy
    end
  end

  def set_post
    @comment = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
