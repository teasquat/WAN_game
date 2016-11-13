local gamera = require("lib/gamera")
local light = require("lib/light")
local bump = require("lib/bump")
love.graphics.setDefaultFilter("nearest", "nearest")
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
make_player = function(x, y, w, h)
  local Player
  Player = require("game_objects").Player
  local player = Player(x, y, w, h)
  player:add_gun(12, 0, 100)
  world:add(player, x, y, w, h)
  return table.insert(game_objects, player)
end
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
  camera:setScale(2, 2)
  local level = love.graphics.newImage("assets/levels/0.png")
  return load_map(level:getData())
end
love.update = function(dt)
  love.window.setTitle("_business(" .. tostring(love.timer.getFPS()) .. ")")
  local _list_0 = game_objects
  for _index_0 = 1, #_list_0 do
    local v = _list_0[_index_0]
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
      local _list_0 = game_objects
      for _index_0 = 1, #_list_0 do
        local v = _list_0[_index_0]
        if v.draw then
          v:draw()
        end
      end
    end)
  end)
end
love.keypressed = function(key)
  local _list_0 = game_objects
  for _index_0 = 1, #_list_0 do
    local v = _list_0[_index_0]
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
        make_player(x * 16, y * 16, 16, 16)
      elseif r == 255 and g == 255 and b == 0 then
        a = light_world:newLight(x * 16, y * 16, 255, 255, 255, 450)
        a:setSmooth(-1)
      end
    end
  end
end
