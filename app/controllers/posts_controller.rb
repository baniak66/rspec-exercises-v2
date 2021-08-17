class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  # GET /posts
  def index
    if params[:sample]
      posts = Post.last(params[:sample])
    else
      posts = Post.all
    end

    render json: Posts::Representers::Multiple.new(posts).call
  end

  # GET /posts/1
  def show
    render json: Posts::Representers::Single.new(@post).call
  end

  # POST /posts
  def create
    post = Posts::UseCases::Create.new(post_params).call

    if post.valid?
      render json: Posts::Representers::Single.new(post).call, status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    post = Posts::UseCases::Update.new(params[:id], post_params).call

    if post.errors.any?
      render json: post.errors, status: :unprocessable_entity
    else
      render json: Posts::Representers::Single.new(post).call
    end
  end

  # DELETE /posts/1
  def destroy
    Posts::UseCases::Delete.new(params[:id]).call
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
