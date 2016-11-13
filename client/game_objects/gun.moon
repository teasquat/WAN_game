class Gun
  ----------------------------------
  -- x and y are offsets to the mother object ...
  ----------------------------------
  new: (@x, @y, @ammo, @w = 14, @h = 4) =>
    @image   = love.graphics.newImage "assets/sheets/gun.png"
    @image_n = love.graphics.newImage "assets/sheets/gun.png"

    @sprite  = light_world\newImage @image, @x, @y
    @sprite\setNormalMap @image_n

    @bullet_speed = 15
    @projectiles  = {}

  set_image: (path) =>
    @image = love.graphics.newImage path

  update: (mother, @dir) =>
    @sprite.x = mother.x + @x * @dir
    @sprite.y = mother.y + @y

    for b in *@projectiles
      b.rect.x += @bullet_speed * b.dir

  draw: =>
    for b in *@projectiles
      love.graphics.setColor 0, 0, 0
      love.graphics.polygon "fill", b.rect\getPoints!

    love.graphics.setColor 255, 255, 255
    love.graphics.draw @image, @sprite.x, @sprite.y, 0, 1 * (@dir or 1), 1, @image\getWidth! / 2, @image\getWidth! / 2

  shoot: (a) =>
    rect = light_world\newRectangle @sprite.x + @w, @sprite.y + @h, 4, 4
    table.insert @projectiles, {:rect, dir: @dir}
