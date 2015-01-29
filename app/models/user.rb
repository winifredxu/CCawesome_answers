class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  has_many :likes, dependent: :nullify #associate with LIKE model
  has_many :liked_questions, through: :likes, source: :question

  has_many :favorites, dependent: :nullify #associate with FAVORITE model
  has_many :favorited_questions, through: :favorites, source: :question

  def has_liked?(question)
  	#Like.where(user_id: id, question_id: question.id).present? 
  	liked_questions.include? question
  end

  def has_favorited?(question)
  	favorited_questions.include? question
  end
  
end
