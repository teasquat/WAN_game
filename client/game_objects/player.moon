class Player
  new: (@x, @y, @w, @h) =>
    @dx, @dy      = 0, 0
    @friction     = 0.1
    @friction_v   = 2
    @acceleration = 30
    @gravity      = 50
    @jump_height  = 7

    @set_controls "a", "d", "space"

    @rect = light_world\newRectangle @x, @y, @w, @h

  set_controls: (@left, @right, @jump) =>

  draw: =>
    love.graphics.setColor 0, 0, 0
    love.graphics.polygon "fill", @rect\getPoints!

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

  press: (key) =>
    if key == "space"
      if @grounded
        @dy = -@jump_height
