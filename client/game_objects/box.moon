----------------------------------
-- The base of all world things.
----------------------------------
class Box
  new: (@x, @y, @w, @h) =>
    @rect = light_world\newRectangle @x, @y, @w, @h

  update: (dt) =>

  move: (dx, dy) =>
    world\move @, @x + dx, @y + dy

  scale: (sx, sy) =>
    world\update @, @x, @y, @w * sx, @h * sy

  draw: =>
    love.graphics.setColor 0, 0, 0
    love.graphics.polygon "fill", @rect\getPoints!
