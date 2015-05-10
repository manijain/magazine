class CommentsController < ApplicationController

	before_action :require_user, only: :create
	before_action :check_valid_user, only: :destroy

	def create
		@article = Article.find(params[:article_id])
		@comment = @article.comments.create(comment_params)
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
		params.require(:comment).permit(:description, :user_id => current_user.id)
	end

	def require_user
		unless current_user.present?
			redirect_to new_user_session_path, :notice => "You need to signin before create comment."
		end
	end

	def check_valid_user
		@article = Article.find(params[:article_id])
		@comment = @article.comments.find(params[:id])
		unless current_user.present? && current_user.id == @comment.user.id
			redirect_to article_path(@article), alert: "You can't delete this comment."
		end
	end
end
