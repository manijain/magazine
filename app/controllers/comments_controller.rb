class CommentsController < ApplicationController
	before_action :require_user, only: [:create, :destroy]
	before_action :check_valid_user, only: :destroy


	def create
		@article = Article.find(params[:article_id])
				
		@comment = @article.comments.create(:description => params[:comment][:description], :article_id => params[:article_id], :parent_id => params[:parent_id], :user_id => current_user.id)
	
		redirect_to article_path(@article)
	end

	def destroy
		@article = Article.find(params[:article_id])
		@comment = @article.comments.find(params[:id])
		@comment.destroy
		redirect_to article_path(@article)
	end

	private

	def comment_params
		params.require(:comment).permit(:description, :parent_id, :user_id => current_user.id)
	end

	def check_valid_user
		@article = Article.find(params[:article_id])
		@comment = @article.comments.find(params[:id])
		unless current_user.present? && current_user.id == @comment.user.id
			redirect_to article_path(@article), alert: "You can't delete this comment."
		end
	end
end
