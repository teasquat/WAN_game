local Box
do
  local _class_0
  local _base_0 = {
    move = function(self, dx, dy)
      return world:move(self, self.x + dx, self.y + dy)
    end,
    scale = function(self, sx, sy)
      return world:update(self, self.x, self.y, self.w * sx, self.h * sy)
    end,
    draw = function(self)
      love.graphics.setColor(255, 255, 255)
      return love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.w / 2, self.h / 2)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h, path)
      self.x, self.y, self.w, self.h = x, y, w, h
      self.image = love.graphics.newImage(path)
      self.image_n = love.graphics.newImage(path)
      self.sprite = light_world:newImage(self.image, self.x, self.y)
      return self.sprite:setNormalMap(self.image_n)
    end,
    __base = _base_0,
    __name = "Box"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Box = _class_0
  return _class_0
end
