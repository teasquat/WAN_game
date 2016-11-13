class Gun
  ----------------------------------
  -- x and y are offsets to the mother object ...
  ----------------------------------
  new: (@x, @y, @ammo, @w = 14, @h = 4) =>
    @rect = light_world\newRectangle @x, @y, @w, @h

    @bullet_speed = 40
    @projectiles  = {}

  set_image: (path) =>
    @image = love.graphics.newImage path

  update: (mother, dir) =>
    @rect.x = mother.x + @x * dir
    @rect.y = mother.y + @y

    for b in *@projectiles
      b.x += @bullet_speed

  draw: =>
    for b in *@projectiles
      love.graphics.setColor 0, 0, 0
      love.graphics.polygon "fill", b.rect\getPoints!

    love.graphics.setColor 255, 0, 0
    love.graphics.polygon "fill", @rect\getPoints!

  shoot: (a) =>
    table.insert @projectiles, {@x + @w, @y + @y}
