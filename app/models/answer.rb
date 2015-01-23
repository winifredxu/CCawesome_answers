class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  has_many :comments, dependent: :destroy

  validates :body, presence: true
  def user_first_name
  	user.first_name if user
  end

end
