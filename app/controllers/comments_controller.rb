class CommentsController < ApplicationController
	before_action:find_answer
	before_action:find_comment, only: [:destroy]
	before_action :authenticate_user!

	def create
		#		render text: params
		@comment = Comment.new comment_params
		@comment.answer = @answer
		# @comment.answer_id = @answer.id   <-- shorter line above
		@comment.user = current_user
		if @comment.save 
			#redirect_to question_path(@answer.question)  --> this is the long hand
			redirect_to @answer.question, notice: "Comment created successfully."
		else
			render "questions/show"  #render takes the template, this is the ERB file path
		end
	end

	def destroy
		@comment.destroy
		#redirect_to @comment.answer.question, notice: "Comment deleted successfully" 
		# use comment.rb's delegate method instead
		redirect_to @comment.question, notice: "Comment deleted successfully"
	end

	private

	def find_answer
		@answer = Answer.find params[:answer_id]
	end
	def find_comment
		@comment = Comment.find params[:id]
	end
	def comment_params
		# use strong params to ensure only the fields explicitly stated are allowed
		params.require(:comment).permit(:body)
	end
end
