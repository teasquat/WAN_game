----------------------------------
-- The base of all world things.
----------------------------------
class Box
  new: (@x, @y, @w, @h) =>

  move: (dx, dy) =>
    world\move @, @x + dx, @y + dy

  scale: (sx, sy) =>
    world\update @, @x, @y, @w * sx, @h * sy

  draw: =>
    love.graphics.setColor 0, 0, 0
    love.graphics.rectangle "fill", @x, @y, @w, @h
