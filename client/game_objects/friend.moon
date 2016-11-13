class Friend
  new: (@x, @y, @w, @h) =>
    @dx, @dy      = 0, 0
    @friction     = 0.1
    @friction_v   = 2
    @acceleration = 35
    @gravity      = 50

    @image   = love.graphics.newImage "assets/sheets/player/naked.png"
    @image_n = love.graphics.newImage "assets/sheets/player/naked.png"

    @sprite  = light_world\newImage @image, @x, @y
    @sprite\setNormalMap @image_n

    @weapons = {}

    ----------------------------------
    -- [-1, 1] : left/right
    -- for gun aim and sprite rendering
    ----------------------------------
    @direction = -1

  add_gun: (x, y, a) =>
    import Gun from require "game_objects"

    table.insert @weapons, Gun x, y, a

  draw: =>
    print "yooo"
    love.graphics.setColor 255, 255, 255
    love.graphics.draw @image, @x, @y, 0, @direction, 1, @w / 2, @h / 2

    for w in *@weapons
      w\draw!

  update: (dt) =>
    @dx -= (@dx / @friction) * dt
    @dy -= (@dy / @friction_v) * dt

    @x += @dx
    @y += @dy
    @sprite.x, @sprite.y = @x, @y

    temp_dir   = math.sign @dx
    @direction = temp_dir unless temp_dir == 0

    for w in *@weapons
      w\update @, @direction
