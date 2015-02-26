class Twitter::SendTweet

  include Virtus.model #to use the Virtus gem for the Service object
 
  attribute :user, User
  attribute :tweet_body, String

  def call
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_API_KEY"]
      config.consumer_secret     = ENV["TWITTER_API_SECRET"]
      config.access_token        = user.twitter_consumer_token
      config.access_token_secret = user.twitter_consumer_secret
    end
    client.update tweet_body
    # client.update @question.title
  end

end