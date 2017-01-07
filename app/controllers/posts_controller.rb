class PostsController < ApplicationController
    
    def index
        @posts = Post.order('created_at DESC')
    end
    
    def new
        if current_user.try(:admin?)
            @post = Post.new
        else
            redirect_to root_path
        end
    end
    
    def create
        @post = Post.new(post_params)
        
        if @post.save
            redirect_to @post
        else
            render 'new'
        end
    end
    
    def show
        @post = Post.find(params[:id])
    end
    
    def edit
        @post = Post.find(params[:id])
    end
    
    def update
        authorize! :update, @post
        @post = Post.find(params[:id])
        
        if @post.update(params[:post].permit(:title, :body))
            redirect_to @post
        else
            render 'edit'
        end
    end
    
    def destroy
        authorize! :destroy, @post
        @post = Post.find(params[:id])
        @post.destroy
        
        redirect_to posts_path
    end
    
    private
        def post_params
            params.require(:post).permit(:title, :body)
        end
end