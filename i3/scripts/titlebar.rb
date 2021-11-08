#!/bin/ruby

require "i3ipc"

while true do begin

con1 = I3Ipc::Connection.new
con2 = I3Ipc::Connection.new

block = Proc.new do |reply|
  if reply.change == 'floating'
    if reply.container.floating == 'user_off'
      con2.command("border pixel 5")
    elsif reply.container.floating == 'user_on' and not (reply.container.name.nil? or reply.container.name.include? 'conky' or reply.container.name.include? 'plank')
      con2.command("border normal 5")
    end
  end
end

pid = con1.subscribe("window", block)
pid.join

rescue nil
end

end
