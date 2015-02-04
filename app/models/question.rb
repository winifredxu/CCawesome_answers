class Question < ActiveRecord::Base
	belongs_to :user
	has_many :answers, dependent: :destroy  #one to many ERD related, 
	# some times has dependent: nullify
	has_many :comments, through: :answers  #associate question with many comments, through answers

  has_many :likes, dependent: :destroy #association with LIKE model
  has_many :liked_users, through: :likes, source: :user

  has_many :favorites, dependent: :destroy #associate with FAVORITE model
  has_many :favorited_users, through: :favorites, source: :user

  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  
  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations, source: :user

	validates :title, presence: true, uniqueness: {scope: :body, case_sensitive: false}
	validates :body, presence: { message: "must be provided!"}

	#validates :view_count, numericality: {greater_than_or_equal_to: 0}

	validate :stop_words

	# Initialize -> Validate -> Save -> Commit  ===  4 stages where callbacks can be inserted
	after_initialize :set_defaults 
	before_save :cap_title


	scope :recent, lambda { |x| order("updated_at DESC").limit(x) }
	# this is the same as below -- returns the x most recent DB entries
	#def self.recent(number)
	#  order("updated_at DESC").limit(number)
	#end

	scope :last_x_days, lambda { |x| where(created_at: x.days.ago..Time.now) }
#scope :last_y_days, lambda { |y| order("updated_at  < CURRENT_DATE - INTEVAL '#{}'")}
#scope :last_z_days, lambda { |z| where("created_at > ?", num.days.ago) }


	def to_param  # friendly URL IDs, overwrites the default to_param of just :id
		"#{id}-#{title}".parameterize
	end

	def likes_count
		likes.count    # length() is less accurate than count() in the DB.
	end
	
	def favorites_count
		favorites.count
	end

	def user_first_name
		user.first_name if user
	end

	private

	def stop_words
		if title.present? && title.include?("monkey")
			errors.add(:title, "PLease don't use monkey!")
		end
	end

	def set_defaults  #set the default view_count to "1"
		self.view_count ||= 1
	end

	def cap_title
		self.title.capitalize!	
	end

end
