require 'sunlight'
Sunlight::Base.api_key = ENV["SUNLIGHT_KEY"]

congresspeople = Sunlight::Legislator.all_in_zipcode('80206')

congresspeople.each do |peep|
  puts "#{peep.firstname} #{peep.lastname} (#{peep.district})"
end
