class Player extends Box
  new: (x, y, w, h) =>
    super x, y, w, h

    @dx, @dy      = 0, 0
    @friction     = 0.25
    @acceleration = 10

    @set_controls "a", "d", "space"

  set_controls: (@left, @right, @jump) =>

  update: (dt) ->
    if love.keyboard.isDown @left
      @dx += @acceleration * dt
    if love.keyboard.isDown @right
      @dx -= @acceleration * dt

    @dx -= (@dx / @friction) * dt
    @dy -= (@dy / @friction) * dt

    @x, @y, @cols = world\move @, @x + @dx, @y + @dy

    for v in *@cols
      if v.normal.y == -1
        @grounded = true
      if v.normal.x ~= 0
        @dx = 0
