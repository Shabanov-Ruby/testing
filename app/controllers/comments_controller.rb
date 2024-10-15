# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @comment = @post.comments.create!(comment_params.merge(user: current_user))
    redirect_back(fallback_location: root_path)
  end

  def edit; end
  # TODO: написать джобу и вставить этот код
  
  # ActiveRecord::Base.transaction do
  #   delete_sub_comments(@comment)
  #   @comment.destroy!
  # end

  #def delete_sub_comments(comment)
  #  comment.replies.each do |child|
  #    delete_sub_comments(child)
  #    child.destroy!
  #  end
  #end

  def destroy
    @comment.soft_delete
    flash[:notice] = 'Комментарий успешно удален.'
    redirect_back(fallback_location: root_path)
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = 'Комментарий обновлен.' 
      redirect_to posts_path
    else
      redirect_to edit_post_comment_path(@comment), notice: 'Комментарий не удалось обновить.'
    end
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  private


  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

end
