class Gun
  ----------------------------------
  -- x and y are offsets to the mother object ...
  ----------------------------------
  new: (@x, @y, @ammo, @w = 14, @h = 4) =>
    @rect = light_world\newRectangle @x, @y, @w, @h

  update: (mother) =>
    @rect.x = mother.x + @x
    @rect.y = mother.y + @y

    @rect\setRotation mother.a

  draw: =>
    love.graphics.setColor 255, 0, 0
    love.graphics.polygon "fill", @rect\getPoints!

  shoot: (a) =>
