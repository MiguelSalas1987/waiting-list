require "clockwork"

class Test
  def self.call( time)
     puts "===hello again=== at #{time}"
  end
end

module Clockwork
  handler { |job, time|  job.call(time) }
  every(3.seconds, Test)
end
