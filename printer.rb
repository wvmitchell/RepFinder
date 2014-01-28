require 'redis-queue'

class Printer

  def intialize
    @out_queue = Redis::Queue.new('to_print', 'printing', :redis => Redis.new)
  end

  def print
    @out_queue.process do |message|
      puts message
    end
  end
end
