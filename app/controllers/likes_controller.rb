class LikesController < ApplicationController
	before_action :find_question;
	before_action :authenticate_user!;

	def create
		like = @question.likes.new 
		like.user = current_user
		if like.save
			redirect_to @question, notice: "Liked!"
		else
			redirect_to @question, alert: "Liked already!"
		end
	end

	def destroy
		like = @question.likes.find(params[:id])
		if like.destroy
			redirect_to @question, notice: "Unliked successfully"
		else
			redirect_to @question, alert: "Can't unlike"
		end
	end

	private

	def find_question
		@question = Question.friendly.find(params[:question_id]);		
	end
end
