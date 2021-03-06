class QuestionsController < ApplicationController
	before_action :find_question, only: [:show, :edit, :update, :destroy] #:new, :create, :index does not need individual element IDs
	before_action :authenticate_user!, except: [:index, :show]
	#before_action :restrict_access, only: [:edit, :update, :destroy]
	before_action :restrict_access, only: [:destroy]

	# used to show the form to create the resource, "new" action leads to "create" submit in form
	def new
		@question = Question.new
	end
	
	#used to create the resources, expect to receive params submitted from the form shown in the new page
	def create
		#use explicit field permission in submission, "strong parameter" started in Rails v4
		# refractored into def question_params method

		@question = Question.new question_params
		@question.user = current_user # this adds the user_id to the questions DB table
		
		if @question.save
			if @question.tweet_it == 
				service = Twitter::SendTweet.new(user: current_user, tweet_body: @question.title)
				service.call
			end

			#render text: "thank you!"
			# shortcut for this is below:  redirect_to question_path(@question)

			redirect_to @question, notice: "Question created successfully."
		else
			#show the form again with error
			
			#render "questions/new" -- the new.html.erb again here, short hand below	
			render :new  # layout: new_layout, render 'new.html.erb'

		end
	end


	def show
		#render text:params
		#find is set in before_action
		if @question != nil
			# @question.view_count +=1
			# @question.save
			@question.increment!(:view_count)
		end

		@answer = Answer.new
#		@answers = @question.answers   # move this to show.html.erb @question.answers.each
		respond_to do |format|
			format.html { render }  #render 'show.html.erb'
			format.json { render json: @question.to_json }
			format.text { render text: @question.title }
			format.xml  { render xml: @question.to_xml }
		end
	end	

	def index
		@entire_questions = Question.all.order('title ASC')

		@questions_recent = Question.recent(3)
	end


	# "edit" action leads to "update" submit in form
	def edit
		#find is set in before_action
		redirect_to root_path, alert: "access denied" unless can? "edit", @question
	end

	def update
		#find is set in before_action	
		#question_params was a variable before, now set as a method below

		if @question.update question_params
			#redirect_to @question, notice: "Question updated successfully"
			redirect_to root_path, alert: "access denied" unless can? "update", @question
		else
			# render "questions/edit"
			render :edit
		end
	end

	def destroy
		#find is set in before_action
		@question.destroy
		redirect_to questions_path, notice: "Question deleted successfully"
	end

	def find_question
		# @question = Question.find params[:id]  -- to use friendlyID url
		@question = Question.friendly.find params[:id]
	end

	def question_params
		# use strong params to ensure only the fields explicitly stated are allowed
		params.require(:question).permit(:title, :body, :image, :tweet_it,
				{category_ids: []}, 
				{collaboration_ids: []} )
	end

	def restrict_access
		# 'cancancan' controller level restrictions
		unless can? :manage, @question
			redirect_to root_path, alert: "access denied" 
		end
	end

end