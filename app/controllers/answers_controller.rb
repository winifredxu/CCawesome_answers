class AnswersController < ApplicationController
	before_action :find_question
	before_action :find_answer, only: [:destroy]
	before_action :authenticate_user! 
	def create
		#render text:params  # show params in text on HTML page

		@answer = Answer.new answer_params     #combine these two lines
		@answer.question = @question
#		@answer.question_id = params[:question_id]
		#@answer = @question.answers.new answer_params
		@answer.user = current_user

		respond_to do |format|  # this is for AJAX

			if @answer.save 
				#AnswersMailer.notify_question_owner(@answer).deliver
				AnswersMailer.notify_question_owner(@answer).deliver_later
				#redirect_to question_path(@question)  --> this is the long hand
				#redirect_to @question, notice: "Answer created successfully."
				format.html {redirect_to @question, notice: "Answer created successfully."}
				format.js { render } #render to "/answers/create.js.erb" success case
				#format.js { render js: "alert('success');" }
			else
				format.html { render "questions/show" } #render takes the template, this is the ERB file path
				format.js { render }  #render to "/answers/create.js.erb" failure case
			end
		end

	end

	def destroy
=begin
		#render text:params   <-- gives back the below params hash list:
		{"_method"=>"delete", "authenticity_token"=>"fodM4cGxGDB4b9w/q0pBRCFpwdWDyLda28OunH6CSEZm7SG3bhXx4JhPaHqfHwJ1i1w0vY4kkCgZYSUdbwv+mQ==", "controller"=>"answers", "action"=>"destroy", "question_id"=>"4", "id"=>"18"}
=end
		@answer.destroy
		respond_to do |format|
			format.js { render }  #this is rendering "comments/destroy.js.erb"
			#format.js { render js: "alert('deleted');"} 
			#in JS, do not redirect_to, only use    window.location.reload();
			format.html { redirect_to question_path(@question), notice: "Answer deleted successfully" }
		end
	end

	private

	def find_question
			@question = Question.find params[:question_id]
	end
	def find_answer
		# @answer = Answer.find params[:id]
		# @answer= current_user.answers.find params[:id]  #only find answers belong to that user
		@answer= current_user.answers.friendly.find params[:id]
	end
	def answer_params
		# use strong params to ensure only the fields explicitly stated are allowed
		params.require(:answer).permit(:body)
	end
end