class Player
  new: (@x, @y, @w, @h) =>
    @dx, @dy      = 0, 0
    @friction     = 0.1
    @friction_v   = 2
    @acceleration = 35
    @gravity      = 50
    @jump_height  = 8.5

    @set_controls "a", "d", "space"

    @rect = light_world\newRectangle @x, @y, @w, @h

    @weapons = {}

  add_gun: (x, y, a) =>
    import Gun from require "game_objects"

    table.insert @weapons, Gun x, y, a

  set_controls: (@left, @right, @jump) =>

  draw: =>
    love.graphics.setColor 0, 0, 0
    love.graphics.polygon "fill", @rect\getPoints!

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
    @rect.x, @rect.y = @x, @y

    camera.x = math.lerp camera.x, @x, dt
    camera.y = math.lerp camera.y, @y, dt / 2

    @grounded = false
    for v in *@cols
      if v.normal.y ~= 0
        if v.normal.y == -1
          @grounded = true
        @dy = 0

      if v.normal.x ~= 0
        @dx = 0

    @aim love.mouse.getX!, love.mouse.getY!

  press: (key) =>
    if key == @jump
      if @grounded
        @dy = -@jump_height
    elseif key == "lshift"
      for w in *@weapons
        w\shoot 0

  ----------------------------------
  -- Calculate fancy offsets for gun - circle
  -- Aim gun in direction - atan2
  ----------------------------------
  aim: (x, y) =>
    a  = math.atan2 @x - x, @y - y

    cx = @x + @w / 3 * math.cos a
    cy = @y + @h / 3 * math.sin a

    for w in *@weapons
      w\update {
        x: cx
        y: cy
        :a
      }
