local Gun
do
  local _class_0
  local _base_0 = {
    update = function(self, mother)
      self.rect.x = mother.x + self.x
      self.rect.y = mother.y + self.y
      return self.rect:setRotation(mother.a)
    end,
    draw = function(self)
      love.graphics.setColor(255, 0, 0)
      return love.graphics.polygon("fill", self.rect:getPoints())
    end,
    shoot = function(self, a) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, ammo, w, h)
      if w == nil then
        w = 14
      end
      if h == nil then
        h = 4
      end
      self.x, self.y, self.ammo, self.w, self.h = x, y, ammo, w, h
      self.rect = light_world:newRectangle(self.x, self.y, self.w, self.h)
    end,
    __base = _base_0,
    __name = "Gun"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Gun = _class_0
  return _class_0
end
