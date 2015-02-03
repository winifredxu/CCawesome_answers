class AnswersMailer < ApplicationMailer
  def notify_question_owner (answer)
    @answer = answer
    @question = @answer.question
    @user = @question.user
    mail to: @user.email, subject: "You've got an answer!"    
  end

end
