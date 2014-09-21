class LikesController < ApplicationController
	before_action :authenticate_user!


	def create
		@post = Post.find(params[:post_id])
		@post.likes.create!(user: current_user)

		#check to see if the user already likes this post
		@current_like = current_user.likes.find_by(post_id: @post.id)

		redirect_to posts_url
	end
end
