class TwitterArchiver

  def initialize(tag)

    connection = Mongo::Connection.new
    db = connection[DATABASE_NAME]
    @tweets = db[COLLECTION_NAME]

    @tweets.create_index([['id', 1]], unique: true)
    @tweets.create_index([['tags', 1], ['id', -1]])

    @tag = tag
    @tweets_found = 0

  end

  def update
    puts "Запускается поиск в Twitter для '#{@tag}'..."
    save_tweets_for @tag
    puts "Сохранено твитов: #{@tweets_found}.\n"
  end

  private
    def save_tweets_for(term)

      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "j7AexsPegLRqFt6PmRpj7spJX"
        config.consumer_secret     = "fUVR2Tq3VwAHEouyNdS66IIrCwfHdWxndjSfsmEHRdNkd6sgMu"
        config.access_token        = "213144816-61MlMV5xqVRr42SoqcqNub17EX0Xudg2ztouGYlL"
        config.access_token_secret = "NUc73o06tbBgBuEi3FYcfJyAtgZDD0BS91mVvCfg7SLSF"
      end

      client.search(term, :result_type => 'recent').each do |tweet|
        @tweets_found += 1
        tweet_with_tag = tweet.to_h.merge!(tags: [term])
        @tweets.save(tweet_with_tag)
      end
    end

end