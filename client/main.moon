gamera = require "lib/gamera"
light  = require "lib/light"
bump   = require "lib/bump"

love.graphics.setDefaultFilter "nearest", "nearest"

----------------------------------
-- Game objects
----------------------------------
import Box from require "game_objects"

export make_box = (x, y, w, h) ->
  box = Box x, y, w, h

  world.add box, x, y, w, h
  table.insert game_objects, box

love.load = ->
  export camera       = gamera.new 0, 0, love.graphics.getWidth!, love.graphics.getHeight!
  export world        = bump.newWorld!
  export light_world  = light {
    ambient:              {55, 55, 55}
    refractionStrength:   12
    reflectionVisibility: 0.75
  }

  export light_mouse = light_world\newLight 0, 0, 255, 127, 73, 400
  light_mouse\setGlowStrength 0.001

  ----------------------------------
  -- List of game-objects to be updated and drawn
  ----------------------------------
  export game_objects = {}

love.update = (dt) ->

  love.window.setTitle "_business(#{ love.timer.getFPS! })"

  light_mouse\setPosition (love.mouse.getX! - camera.x) / camera.scale, (love.mouse.getY! - camera.y) / camera.scale

  for v in *game_objects
    v\update dt

  light_world\update dt
  light_world\setTranslation camera.x, camera.y, camera.scale

love.draw = ->
  camera\draw ->
    light_world\draw ->
      love.graphics.setColor 255, 255, 255
      love.graphics.rectangle "fill", -camera.x / camera.scale, -camera.y / camera.scale, love.graphics.getWidth! / camera.scale, love.graphics.getHeight! / camera.scale

      for v in *game_objects
        v\draw!
