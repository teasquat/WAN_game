local gamera = require("lib/gamera")
local light = require("lib/light")
love.load = function()
  camera = gamera.new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  light_world = light({
    ambient = {
      55,
      55,
      55
    },
    refractionStrength = 32,
    reflectionVisibility = 0.75
  })
end
love.update = function(dt) end
love.draw = function()
  return camera:draw(function()
    return light_world:draw(function()
      return love.graphics.setColor(255, 255, 255)
    end)
  end)
end
