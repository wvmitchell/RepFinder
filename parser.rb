require 'csv'
require 'redis-queue'

class Parser

  attr_reader :file

  def initialize
    @file = 'attendees.csv'
    @queue = Redis::Queue.new("waiting", "processing", :redis => Redis.new)
  end

  def parse
    csv_with_headers = CSV.open file, headers: true, header_converters: :symbol
    csv_with_headers.each do |row|
      id = row[0]
      zip = row[:zipcode].to_s.rjust(5, '0')
      name = row[:first_name] + " " + row[:last_name]
      publish_to_channel(id, zip, name)
    end
    csv_with_headers.close
  end

  def publish_to_channel(id, zip, name)
    @queue.push(id + "," + zip + "," + name)
  end

end
