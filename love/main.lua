local gamera = require("lib/gamera")
local light = require("lib/light")
love.graphics.setDefaultFilter("nearest", "nearest")
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
  light_mouse = light_world:newLight(0, 0, 255, 127, 63, 300)
  light_mouse:setGlowStrength(0.3)
  rect = light_world:newRectangle(512, 512, 64, 64)
end
love.update = function(dt)
  light_mouse:setPosition((love.mouse.getX() - camera.x) / camera.scale, (love.mouse.getY() - camera.y) / camera.scale)
  light_world:update(dt)
  return light_world:setTranslation(camera.x, camera.y, camera.scale)
end
love.draw = function()
  return camera:draw(function()
    return light_world:draw(function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", -camera.x / camera.scale, -camera.y / camera.scale, love.graphics.getWidth() / camera.scale, love.graphics.getHeight() / camera.scale)
      love.graphics.setColor(63, 255, 127)
      return love.graphics.polygon("fill", rect:getPoints())
    end)
  end)
end
