class HomePageController < ApplicationController
    before_action :authenticate_user!

    def index
        @users = User.where.not(id: current_user.id) 
        @my_posts = current_user.posts.order(created_at: :desc)
        following_ids = current_user.following.pluck(:id)
      @following_posts = Post.where(user_id: following_ids).where.not(user_id: current_user.id).order(created_at: :desc) 
    end
    
end
