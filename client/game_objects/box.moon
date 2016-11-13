----------------------------------
-- The base of all world things.
----------------------------------
class Box
  new: (@x, @y, @w, @h, path) =>
    @image   = love.graphics.newImage path
    @image_n = love.graphics.newImage path

    @sprite  = light_world\newImage @image, @x, @y
    @sprite\setNormalMap @image_n

  move: (dx, dy) =>
    world\move @, @x + dx, @y + dy

  scale: (sx, sy) =>
    world\update @, @x, @y, @w * sx, @h * sy

  draw: =>
    love.graphics.setColor 255, 255, 255
    love.graphics.draw @image, @x, @y, 0, 1, 1, @w / 2, @h / 2
