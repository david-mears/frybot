require './good_morning.rb'
require 'twitter'

@client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
  config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
  config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
  config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
end

@old_greetings = []

File.new('phrases_already_posted_to_twitter.txt', 'r').read.each_line do |line|
  old_greetings.push(line.tr("\n"))
end

@favourites_store_phrases = []

File.new('favourites_store.txt', 'r').read.each_line do |line|
  @favourites_store_phrases.push(line.tr("\n", ""))
end

def generate_phrase_and_update_twitter
  new_greeting = [generate_phrase[0], @favourites_store_phrases.sample].sample

  if @old_greetings.include? new_greeting
    # retry
    generate_phrase_and_update_twitter
  else
    @client.update(new_greeting)
    open('phrases_already_posted_to_twitter.txt', 'a') { |f| f << new_greeting + "\n" }
  end
end

generate_phrase_and_update_twitter
