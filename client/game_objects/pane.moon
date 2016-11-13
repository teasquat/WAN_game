----------------------------------
-- The base of all world things.
----------------------------------
class Box
  new: (@x, @y, @w, @h) =>

  update: (dt) =>

  move: (dx, dy) =>
    world\move @, @x + dx, @y + dy

  scale: (sx, sy) =>
    world\update @, @x, @y, @w * sx, @h * sy

  draw: =>
    love.graphics.setColor 255, 255, 255
    love.graphics.rectangle "fill", @x, @y, @w, @h
