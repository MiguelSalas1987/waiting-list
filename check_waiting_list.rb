require "clockwork"
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'midnight.job'){ Request.check_waiting_list}
end
