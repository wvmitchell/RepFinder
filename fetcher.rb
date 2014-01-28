require 'redis-queue'
require 'sunlight'

class Fetcher

  Sunlight::Base.api_key = ENV["SUNLIGHT_KEY"]

  def initialize
    @queue_in = Redis::Queue.new("waiting", "processing", :redis => Redis.new)
    @queue_out = Redis::Queue.new("to_print", "printing", :redis => Redis.new)
  end

  def fetch
    @queue_in.process do |fetched|
      info = fetched.split(',')
      legislators = Sunlight::Legislator.all_in_zipcode(info[1])
      names = legislators.collect {|legislator| legislator.firstname + ' ' + legislator.lastname}
      @queue_out.push(fetched + ' ' + names.to_s)
    end
  end
end
