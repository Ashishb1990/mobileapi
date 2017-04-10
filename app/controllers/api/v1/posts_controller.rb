class Api::V1::PostsController < Api::V1::ApiController

	before_action :authenticate_user!

 #url : http://localhost:3000/api/v1/posts?user_token=BMggmozss3ww1rBsbYYM
 #methode-type : Get
  def index
  	posts = Post.where(:user_id => current_user.id)
  	render :status=>200, :json=>{:status => true, :posts=> posts}
  end
  def new
     @post = Post.new
  end
 #url : http://localhost:3000/api/v1/posts
 #methode-type : Post
 # {"title":"ashish1@gmail.com","description":"12345678","user_token": "BMggmozss3ww1rBsbYYM" }
  def create
    @post = Post.new(title: params[:title], description: params[:description], user_id: current_user.id)
      if @post.save
        render :status=>200, :json=> { status: :created, post: @post }
      else
        render :status=>401, :json=> { error: @post.errors, status: :unprocessable_entity }
      end
    end
end
