socket = require "socket"
udp = socket.udp!
port = 7788

udp\settimeout 0
udp\setsockname '*', port

data, msg_or_ip, port_or_nil
entities = {}
running = true

print "Beginning server loop."

while running do
  data, msg_or_ip, port_or_nil = udp\receivefrom!

  if data
    action, id, value = data\match "^(%a*)_(%d*)_(.*)" --move_847548356_720:100:2:-1

    if action == "update"
      for i, v in pairs entities
        udp\sendto i .. "_" .. v, msg_or_ip, port_or_nil

    elseif action == "move"
      entities[id] = value

    elseif action == "delete"
      entities[id] = nil

    elseif action == "quit"
      print("kys")
      break

  elseif msg_or_ip ~= 'timeout' then
    error "Unknown network error: " .. tostring msg_or_ip

  socket.sleep 0.01
