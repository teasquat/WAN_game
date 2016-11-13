class Camera
  new: (@x = 0, @y = 0, @sx = 1, @sy = 1, @r = 0) =>

  set: =>
    love.graphics.push!
    love.graphics.translate @get_width! * 2, @get_height! * 2

    love.graphics.rotate -@r

    love.graphics.translate -@get_width! * 2, @get_height! * 2
    love.graphics.scale 1 / @sx, 1 / @sy
    love.graphics.translate -@x, -@y

  unset: =>
    love.graphics.pop!

  get_width: =>
    love.graphics.getWidth! * @sx

  get_height: =>
    love.graphics.getHeight! * @sy
