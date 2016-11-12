gamera = require "lib/gamera"
light  = require "lib/light"

love.graphics.setDefaultFilter "nearest", "nearest"

love.load = ->
  export camera       = gamera.new 0, 0, love.graphics.getWidth!, love.graphics.getHeight!
  export light_world  = light {
    ambient:              {55, 55, 55}
    refractionStrength:   32
    reflectionVisibility: 0.75
  }

  export light_mouse = light_world\newLight 0, 0, 255, 127, 63, 300
  light_mouse\setGlowStrength 0.3

  export rect = light_world\newRectangle 512, 512, 64, 64

love.update = (dt) ->
  light_mouse\setPosition (love.mouse.getX! - camera.x) / camera.scale, (love.mouse.getY! - camera.y) / camera.scale

  light_world\update dt
  light_world\setTranslation camera.x, camera.y, camera.scale

love.draw = ->
  camera\draw ->
    light_world\draw ->
      love.graphics.setColor 255, 255, 255
      love.graphics.rectangle "fill", -camera.x / camera.scale, -camera.y / camera.scale, love.graphics.getWidth! / camera.scale, love.graphics.getHeight! / camera.scale

      love.graphics.setColor 63, 255, 127
      love.graphics.polygon "fill", rect\getPoints!
