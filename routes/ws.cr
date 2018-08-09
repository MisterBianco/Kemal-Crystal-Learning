require "kemal"

ws "/socket" do |socket|
  socket.send "Hello from Kemal!"
end
