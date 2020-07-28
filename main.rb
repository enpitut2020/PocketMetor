require './twitter_client'
require './google_api'
require './firestore_client'

# Firestoreの動作確認
# Twitterインスタンス
twitter_client = TwitterClient.new()
firestore_client = FirestoreClient.new()

tweets = twitter_client.getReplies

tweets.each do | tweet | 
    firestore_client.saveUser(tweet)
    firestore_client.saveTweet(tweet)
end

tweets.each do | tweet | 
    firestore_client.getTweets(tweet.user.id).each do |users_tweet|
        puts users_tweet
    end
end

SLEEP_TIME = 2 * 60

loop {
  # Twitterインスタンス
  boredTweets = twitter_client.getBoredTweets()
  if boredTweets.empty?
    puts "暇ツイートはありません．"
    puts "みんな忙しそう"
  else
    boredTweets.each do |tweet|
      puts tweet.user.screen_name
      puts tweet.text
    end
    twitter_client.setRecentTweet(boredTweets[0].id) unless boredTweets[0].nil?
  end

  sleep(SLEEP_TIME)
}