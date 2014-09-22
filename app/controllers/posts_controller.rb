class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create]

  # GET /posts
  # GET /posts.json
  def index
    #@posts = Post.all
    @feed = []
    @user = current_user
    Post.all.each do |post|
      add_feed(@user, @post)
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @likes = @post.likes
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # GET /posts/:latitude/:longitude?radius=5&old_radius=5
  def feed
    feed_params = params.require(:longitude, :latitude, :radius, :old_radius)
    feed_params[:radius] ||= 10
    feed_params[:old_radius] ||= 0

    Posts.all.filter do |post|
      location_reach = post.distance_to(feed_params[:latitude], feed_params[:longitude], :units => :km) + post.radius
      feed_params[:old_radius] <= location_reach && location_reach <= feed_params[:radius]
    end.sort_by { |post| post.created_at }
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.longitude = current_user.longitude
    @post.latitude = current_user.latitude
    @post.radius = 40.0

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :user, :area, :latitude, :longitude)
    end

    def add_feed(user, post)
      total_distance = user.distance_from([post.latitude, post.longitude])
      if total_distance <= user.radius + post.radius
        @feed << post
      end

    end
end
