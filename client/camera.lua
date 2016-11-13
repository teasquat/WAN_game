local Camera
do
  local _class_0
  local _base_0 = {
    set = function(self)
      love.graphics.push()
      love.graphics.translate(self:get_width() * 2, self:get_height() * 2)
      love.graphics.rotate(-self.r)
      love.graphics.translate(-self:get_width() * 2, self:get_height() * 2)
      love.graphics.scale(1 / self.sx, 1 / self.sy)
      return love.graphics.translate(-self.x, -self.y)
    end,
    unset = function(self)
      return love.graphics.pop()
    end,
    get_width = function(self)
      return love.graphics.getWidth() * self.sx
    end,
    get_height = function(self)
      return love.graphics.getHeight() * self.sy
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, sx, sy, r)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      if sx == nil then
        sx = 1
      end
      if sy == nil then
        sy = 1
      end
      if r == nil then
        r = 0
      end
      self.x, self.y, self.sx, self.sy, self.r = x, y, sx, sy, r
    end,
    __base = _base_0,
    __name = "Camera"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Camera = _class_0
  return _class_0
end
