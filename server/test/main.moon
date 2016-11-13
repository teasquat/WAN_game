socket = require "socket"

address, port = "52.59.243.52", 7788

updaterate = 0.1
world = {}
t = updaterate

udp = socket.udp!
udp\settimeout 0
udp\setpeername address, port
math.randomseed os.time!

entity = {
  id:tostring(math.random(99999))
  x:100
  y:10
  dx:0
  dy:0
}
print entity.id

love.update = (dt) ->
  print(dt)
  entity.x += entity.dx*dt
  entity.y += entity.dy*dt
  entity.dx -= entity.dx*dt
  entity.dy -= entity.dy*dt

  if love.keyboard.isDown "right"
    entity.dx += dt*100
  if love.keyboard.isDown "left"
    entity.dx -= dt*100
  if love.keyboard.isDown "down"
    entity.dy += dt*100
  if love.keyboard.isDown "up"
    entity.dy -= dt*100

  for k, v in pairs(world) do
    v.x += v.dx*dt
    v.y += v.dy*dt

  t = t + dt
  if t > updaterate
    udp\send("move_#{entity.id}_#{entity.x}:#{entity.y}:#{entity.dx}:#{entity.dy}")
    udp\send("update__")
    t=t-updaterate -- set t for the next round

    while true
      data, msg = udp\receive!

      if data
        id, value = data\match "^(%d*)_(.*)"
        if id != entity.id
          x, y, dx, dy = value\match "^(.*):(.*):(.*):(.*)"
          print(value)
          print(x,y,dx,dy)
          assert x and y and dx and dy
          x = tonumber x
          y = tonumber y
          dx = tonumber dx
          dy = tonumber dy
          world[id] = {x:x, y:y, dx:dx, dy:dy}

      elseif msg ~= "timeout"
        error("Network error: "..tostring(msg))
      else
        break

love.draw = ->
  love.graphics.setColor 255, 0, 0
  love.graphics.rectangle "fill", entity.x, entity.y, 32, 32

  love.graphics.setColor 255, 255, 255
  for k, v in pairs(world) do
    print(v.x, v.y)
    love.graphics.rectangle "fill", v.x, v.y, 32, 32
