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

love.update = (dt) ->

love.draw = ->
  camera\draw ->
    light_world\draw ->
      love.graphics.setColor 255, 255, 255
