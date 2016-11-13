gamera = require "lib/gamera"
light  = require "lib/light"
bump   = require "lib/bump"

love.graphics.setDefaultFilter "nearest", "nearest"

----------------------------------
-- Math is math is here:
----------------------------------
math.lerp = (a, b, dt) ->
  (1 - dt) * a + dt * b

math.lerp2 = (a, b, dt) ->
  a + (b - a) * dt

math.cerp = (a, b, dt) ->
  f = (1 - (math.cos dt * math.pi)) / 2
  a * (1 - f) + b * f

----------------------------------
-- Game objects
----------------------------------
export make_box = (x, y, w, h) ->
  import Box from require "game_objects"

  box = Box x, y, w, h

  world\add box, x, y, w, h
  table.insert game_objects, box

export make_pane = (x, y, w, h) ->
  table.insert game_objects, Box x, y, w, h

export make_player = (x, y, w, h) ->
  import Player from require "game_objects"

  player = Player x, y, w, h

  world\add player, x, y, w, h
  table.insert game_objects, player

love.load = ->
  export camera       = gamera.new 0, 0, love.graphics.getWidth!, love.graphics.getHeight!
  export world        = bump.newWorld 64
  export light_world  = light {
    ambient:              {100, 100, 100}
    refractionStrength:   1000
    reflectionVisibility: 0
    shadowBlur: 2.0
  }

  ----------------------------------
  -- List of game-objects to be updated and drawn
  ----------------------------------
  export game_objects = {}

  camera\setScale 2, 2

  ----------------------------------
  -- Load level
  ----------------------------------
  level    = love.graphics.newImage "assets/levels/0.png"
  load_map level\getData!

  export render_buffer = love.graphics.newCanvas love.graphics.getWidth!, love.graphics.getHeight!

love.update = (dt) ->
  love.window.setTitle "_business(#{ love.timer.getFPS! })"

  for v in *game_objects
    v\update dt if v.update

  light_world\update dt
  light_world\setTranslation camera.x, camera.y, camera.scale

love.draw = ->
  camera\draw ->
    light_world\draw ->
      love.graphics.setColor 255, 255, 255
      love.graphics.rectangle "fill", -camera.x / camera.scale, -camera.y / camera.scale, love.graphics.getWidth! / camera.scale, love.graphics.getHeight! / camera.scale

      for v in *game_objects
        v\draw! if v.draw

love.keypressed = (key) ->
  for v in *game_objects
    v\press key if v.press

----------------------------------
-- Level loader
----------------------------------
export load_map = (image_data) ->
  for x = 1, image_data\getWidth!
    for y = 1, image_data\getHeight!
      r, g, b, a = image_data\getPixel x - 1, y - 1

      if r + g + b == 0
        make_box x * 16, y * 16, 16, 16
      elseif r + g + b == 815
        make_pane x * 16, y * 16, 16, 16
      elseif r == 255 and g == 0 and b == 0
        make_player x * 16, y * 16, 16, 16
      elseif r == 255 and g == 255 and b == 0
        a = light_world\newLight x * 16, y * 16, 255, 255, 255, 450
        a\setSmooth -1
