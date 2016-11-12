gamera = require "lib/gamera"
light  = require "lib/light"

love.graphics.setDefaultFilter "nearest", "nearest"

love.load = ->
  export camera       = gamera.new 0, 0, love.graphics.getWidth!, love.graphics.getHeight!
  export light_world  = light {
    ambient:              {55, 55, 55}
    refractionStrength:   12
    reflectionVisibility: 0.75
  }

  export light_mouse = light_world\newLight 0, 0, 255, 127, 73, 400
  light_mouse\setGlowStrength 0.001

  export rect = light_world\newRectangle 512, 512, 64, 64
  export circ = light_world\newCircle light_mouse.x, light_mouse.y + 50, 37

love.update = (dt) ->

  love.window.setTitle "_business(#{ love.timer.getFPS! })"

  light_mouse\setPosition (love.mouse.getX! - camera.x) / camera.scale, (love.mouse.getY! - camera.y) / camera.scale

  light_world\update dt
  light_world\setTranslation camera.x, camera.y, camera.scale

love.draw = ->
  camera\draw ->
    light_world\draw ->
      love.graphics.setColor 255, 255, 255
      love.graphics.rectangle "fill", -camera.x / camera.scale, -camera.y / camera.scale, love.graphics.getWidth! / camera.scale, love.graphics.getHeight! / camera.scale

      love.graphics.setColor 50, 255, 50
      cx, cy = circ\getPosition!
      love.graphics.circle "fill", cx, cy, circ\getRadius!
