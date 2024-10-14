class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    if user_signed_in?
      @my_posts = current_user.posts.order(created_at: :desc) 
      @users = User.where.not(id: current_user.id) 
      following_ids = current_user.following.pluck(:id)
      @following_posts = Post.where(user_id: following_ids).where.not(user_id: current_user.id).order(created_at: :desc)
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: 'Публикация создана!'
    else
      render :index, alert: 'Публикация не создана!'
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
