require "clockwork"
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'midnight.job'){ Request.check_waiting_list}
  #for testing purposes replace the line above with the line below
  #every(1.minutes, 'midnight.job'){ Request.check_waiting_list}

end
