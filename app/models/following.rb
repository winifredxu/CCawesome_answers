class Following < ActiveRecord::Base
  belongs_to :user
  # we have to use explict "User" class name because there's no follower class
  belongs_to :follower, class_name: "User"  
end
