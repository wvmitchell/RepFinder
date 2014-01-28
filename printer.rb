require 'redis-queue'
require 'csv'

class Printer

  def initialize
    @out_queue = Redis::Queue.new('to_print', 'printing', :redis => Redis.new)
  end

  def print
    file_out = CSV.open('attendees_with_legislators.csv', 'wb', :headers => true)
    file_out << ['id', 'zipcode', 'name', 'legislators']
    @out_queue.process do |message|
      arr = message.split(',')
      file_out << arr
    end
    file_out.close
  end
end
