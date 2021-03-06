class Player
  new: (@x, @y, @w, @h) =>
    @dx, @dy      = 0, 0
    @friction     = 0.1
    @friction_v   = 2
    @acceleration = 35
    @gravity      = 50
    @jump_height  = 8.5

    @set_controls "a", "d", "space"

    @image   = love.graphics.newImage "assets/sheets/player/naked.png"
    @image_n = love.graphics.newImage "assets/sheets/player/naked.png"

    @suit    = love.graphics.newImage "assets/sheets/suit.png"

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

  set_controls: (@left, @right, @jump) =>

  draw: =>
    love.graphics.setColor 255, 255, 255
    love.graphics.draw @image, @x, @y, 0, @direction, 1, @w / 2, @h / 2
    --love.graphics.draw @suit, @x, @y, 0, @direction, 1, @w / 2, @h / 2

    for w in *@weapons
      w\draw!

  update: (dt) =>
    if love.keyboard.isDown @left
      @dx -= @acceleration * dt
    if love.keyboard.isDown @right
      @dx += @acceleration * dt

    @dy += @gravity * dt

    @dx -= (@dx / @friction) * dt
    @dy -= (@dy / @friction_v) * dt

    @x, @y, @cols = world\move @, @x + @dx, @y + @dy
    @sprite.x, @sprite.y = @x, @y

    camera.x, camera.y = -@x + love.graphics.getWidth! / 7, -@y + love.graphics.getHeight! / 7

    @grounded = false
    for v in *@cols
      if v.normal.y ~= 0
        if v.normal.y == -1
          @grounded = true
        @dy = 0

      if v.normal.x ~= 0
        @dx = 0

    temp_dir   = math.sign @dx
    @direction = temp_dir unless temp_dir == 0

    for w in *@weapons
      w\update @, @direction

  press: (key) =>
    if key == @jump
      if @grounded
        @dy = -@jump_height
    elseif key == "lshift"
      for w in *@weapons
        w\shoot 0
