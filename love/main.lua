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
    refractionStrength = 12,
    reflectionVisibility = 0.75
  })
  light_mouse = light_world:newLight(0, 0, 255, 127, 73, 400)
  light_mouse:setGlowStrength(0.001)
  rect = light_world:newRectangle(512, 512, 64, 64)
  circ = light_world:newCircle(light_mouse.x, light_mouse.y + 50, 37)
end
love.update = function(dt)
  love.window.setTitle("_business(" .. tostring(love.timer.getFPS()) .. ")")
  light_mouse:setPosition((love.mouse.getX() - camera.x) / camera.scale, (love.mouse.getY() - camera.y) / camera.scale)
  light_world:update(dt)
  return light_world:setTranslation(camera.x, camera.y, camera.scale)
end
love.draw = function()
  return camera:draw(function()
    return light_world:draw(function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", -camera.x / camera.scale, -camera.y / camera.scale, love.graphics.getWidth() / camera.scale, love.graphics.getHeight() / camera.scale)
      love.graphics.setColor(50, 255, 50)
      local cx, cy = circ:getPosition()
      love.graphics.circle("fill", cx, cy, circ:getRadius())
      return print(rect.x, rect.y, rect:getPoints())
    end)
  end)
end
