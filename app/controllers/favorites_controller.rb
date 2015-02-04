class FavoritesController < ApplicationController
	before_action :find_question
	before_action :authenticate_user!

	def create
		favorite = @question.favorites.new
		favorite.user = current_user
		if favorite.save
			redirect_to @question, notice: "Favorite successfully"
		else
			redirect_to @question, alert: "Favored already!"
		end
	end

	def destroy
		favorite = @question.favorites.find(params[:id])
		if favorite.destroy
			redirect_to @question, notice: "Unfav successfully."
		else
			redirect_to @question, alert: "can't UN-favorite!"
		end
	end

	private

	def find_question
		@question = Question.friendly.find(params[:question_id])
	end
end
