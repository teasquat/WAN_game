local gamera = require("lib/gamera")
local light = require("lib/light")
local bump = require("lib/bump")
love.graphics.setDefaultFilter("nearest", "nearest")
local socket = require("socket")
local address, port = "localhost", 7788
local update_rate = 0.1
local update_time = update_rate
local udp = socket.udp()
udp:settimeout(0)
udp:setpeername(address, port)
math.lerp = function(a, b, dt)
  return (1 - dt) * a + dt * b
end
math.lerp2 = function(a, b, dt)
  return a + (b - a) * dt
end
math.cerp = function(a, b, dt)
  local f = (1 - (math.cos(dt * math.pi))) / 2
  return a * (1 - f) + b * f
end
math.sign = function(a)
  if a < 0 then
    return -1
  elseif a > 0 then
    return 1
  end
  return 0
end
make_box = function(x, y, w, h)
  local Box
  Box = require("game_objects").Box
  local box = Box(x, y, w, h)
  world:add(box, x, y, w, h)
  return table.insert(game_objects, box)
end
make_pane = function(x, y, w, h)
  return table.insert(game_objects, Box(x, y, w, h))
end
make_player = function(x, y, w, h, id, dx, dy)
  if id == nil then
    id = (math.random(1e5))
  end
  local Player
  Player = require("game_objects").Player
  local player = Player(x, y, w, h)
  player:add_gun(12, 0, 100)
  player.id = id
  if dx then
    player.dx = dx
  end
  if dy then
    player.dy = dy
  end
  world:add(player, x, y, w, h)
  table.insert(game_players, player)
  if not (udp_player_ref) then
    udp_player_ref = player
  end
end
math.randomseed(os.time())
love.load = function()
  camera = gamera.new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  world = bump.newWorld(64)
  light_world = light({
    ambient = {
      100,
      100,
      100
    },
    refractionStrength = 1000,
    reflectionVisibility = 0,
    shadowBlur = 2.0
  })
  game_objects = { }
  game_players = { }
  camera:setScale(2, 2)
  local level = love.graphics.newImage("assets/levels/0.png")
  load_map(level:getData())
  return print(udp_player_ref)
end
love.update = function(dt)
  love.window.setTitle("_business(" .. tostring(love.timer.getFPS()) .. ")")
  update_time = update_time + dt
  if update_time > update_rate and udp_player_ref then
    udp:send("move_" .. tostring(udp_player_ref.id) .. "_" .. tostring(udp_player_ref.x) .. ":" .. tostring(udp_player_ref.y) .. ":" .. tostring(udp_player_ref.dx) .. ":" .. tostring(udp_player_ref.dy))
    udp:send("update__")
    update_time = update_time - update_rate
    while true do
      local data, m = udp:receive()
      if data then
        local id, v = data:match("^(%d*)_(.*)")
        if not ((tonumber(id)) == tonumber(udp_player_ref.id)) then
          local x, y, dx, dy = v:match("^(.*):(.*):(.*):(.*)")
          assert(x and y and dx and dy, "This is not very good!")
          x, y, dx, dy = (tonumber(x)), (tonumber(y)), (tonumber(dx)), tonumber(dy)
          local found = nil
          local _list_0 = game_players
          for _index_0 = 1, #_list_0 do
            v = _list_0[_index_0]
            if (tonumber(v.id)) == tonumber(id) then
              found = v
              break
            end
          end
          if found then
            found.x = x
            found.y = y
            found.dx = dx
            found.dy = dy
          else
            make_player(x, y, 14, 10, (tonumber(id)), dx, dy)
          end
        end
      else
        if not (m == "timeout") then
          error("Networking error: " .. tostring(m))
        else
          break
        end
      end
    end
  end
  local _list_0 = game_players
  for _index_0 = 1, #_list_0 do
    local v = _list_0[_index_0]
    if v.update then
      v:update(dt)
    end
  end
  local _list_1 = game_objects
  for _index_0 = 1, #_list_1 do
    local v = _list_1[_index_0]
    if v.update then
      v:update(dt)
    end
  end
  light_world:update(dt)
  return light_world:setTranslation(camera.x, camera.y, camera.scale)
end
love.draw = function()
  return camera:draw(function()
    return light_world:draw(function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", -camera.x / camera.scale, -camera.y / camera.scale, love.graphics.getWidth() / camera.scale, love.graphics.getHeight() / camera.scale)
      local _list_0 = game_players
      for _index_0 = 1, #_list_0 do
        local v = _list_0[_index_0]
        if v.draw then
          v:draw()
        end
      end
      local _list_1 = game_objects
      for _index_0 = 1, #_list_1 do
        local v = _list_1[_index_0]
        if v.draw then
          v:draw()
        end
      end
    end)
  end)
end
love.keypressed = function(key)
  local _list_0 = game_players
  for _index_0 = 1, #_list_0 do
    local v = _list_0[_index_0]
    if v.press then
      v:press(key)
    end
  end
  local _list_1 = game_objects
  for _index_0 = 1, #_list_1 do
    local v = _list_1[_index_0]
    if v.press then
      v:press(key)
    end
  end
end
load_map = function(image_data)
  for x = 1, image_data:getWidth() do
    for y = 1, image_data:getHeight() do
      local r, g, b, a = image_data:getPixel(x - 1, y - 1)
      if r + g + b == 0 then
        make_box(x * 16, y * 16, 16, 16)
      elseif r + g + b == 815 then
        make_pane(x * 16, y * 16, 16, 16)
      elseif r == 255 and g == 0 and b == 0 then
        make_player(x * 16, y * 16, 10, 14.65)
      elseif r == 255 and g == 255 and b == 0 then
        a = light_world:newLight(x * 16, y * 16, 255, 255, 255, 450)
        a:setSmooth(-1)
      end
    end
  end
end
