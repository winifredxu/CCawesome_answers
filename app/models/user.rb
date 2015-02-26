class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, 
         omniauth_providers: [:twitter]


  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  has_many :likes, dependent: :nullify #associate with LIKE model
  has_many :liked_questions, through: :likes, source: :question

  has_many :favorites, dependent: :nullify #associate with FAVORITE model
  has_many :favorited_questions, through: :favorites, source: :question

  has_many :collaborations, dependent: :destroy
  has_many :collaborated_questions, through: :collaborations, source: :question


  # user --> following <-- user, many-to-many relationship on User model itself
  has_many :followings, dependent: :destroy
  has_many :followers, through: :followings

  has_many :inverse_followings, class_name: "Following", foreign_key: "follower_id"
  has_many :inverse_followers, through: :inverse_followings, source: :user


  serialize :omniauth_raw_data, Hash #Rails automatically translates HASH storage

  #twitter does not provide email for the user so remove the email validations requirement
  def email_required? 
    provider.nil?
    #false
  end
  
  #if create user via a provider, then no password needed either. 
  def password_required?
    provider.nil?
    #return false
  end

  # alias_method :name, :full_name
  def full_name
    if (first_name || last_name)
      "#{first_name} #{last_name}".squeeze(" ").strip
    else
      email
    end
  end

  def has_liked?(question)
  	#Like.where(user_id: id, question_id: question.id).present? 
  	liked_questions.include? question
  end

  def has_favorited?(question)
  	favorited_questions.include? question
  end

  def self.find_or_create_from_twitter(omniauth_data)
    user = User.where(provider: "twitter", uid: omniauth_data["uid"]).first
    unless user
      # create user
      name = omniauth_data["info"]["name"].split(" ") #split " " is default
      user = User.create(provider: "twitter", uid: omniauth_data["uid"], 
                         first_name: name[0], last_name: name[1],
                         # to bypass the password validation, we  a phony password if they sign up via a provider. Or we decide to use the "password_required?" method above
                         #password: Devise.friendly_token,
                         twitter_consumer_token: omniauth_data["credentials"]["token"],
                         twitter_consumer_secret: omniauth_data["credentials"]["secret"],
                         omniauth_raw_data: omniauth_data
                         )
    end

    user  #return user object
  end
end