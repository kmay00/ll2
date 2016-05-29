require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.every("0 22 * * 1-5") do
  # every Mon, Tues, Wed, Thurs, Fri (weekdays) at 10:00pm
  `rake "broward_court:get_lis_pendens"`
  `rake "broward_assessor:get_address"`  
end
