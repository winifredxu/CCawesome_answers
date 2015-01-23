class Comment < ActiveRecord::Base
	belongs_to :user
  belongs_to :answer

  validates :body, presence: true

  # delegate :question, to: :answer
  def question
  	answer.question
  end
  def user_first_name
  	user.first_name if user
  end
end
