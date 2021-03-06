local Gun
do
  local _class_0
  local _base_0 = {
    set_image = function(self, path)
      self.image = love.graphics.newImage(path)
    end,
    update = function(self, mother, dir)
      self.dir = dir
      self.sprite.x = mother.x + self.x * self.dir
      self.sprite.y = mother.y + self.y
      local _list_0 = self.projectiles
      for _index_0 = 1, #_list_0 do
        local b = _list_0[_index_0]
        b.rect.x = b.rect.x + (self.bullet_speed * b.dir)
      end
    end,
    draw = function(self)
      local _list_0 = self.projectiles
      for _index_0 = 1, #_list_0 do
        local b = _list_0[_index_0]
        love.graphics.setColor(0, 0, 0)
        love.graphics.polygon("fill", b.rect:getPoints())
      end
      love.graphics.setColor(255, 255, 255)
      return love.graphics.draw(self.image, self.sprite.x, self.sprite.y, 0, 1 * (self.dir or 1), 1, self.image:getWidth() / 2, self.image:getWidth() / 2)
    end,
    shoot = function(self, a)
      local rect = light_world:newRectangle(self.sprite.x + self.w, self.sprite.y + self.h, 4, 4)
      return table.insert(self.projectiles, {
        rect = rect,
        dir = self.dir
      })
    end
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
      self.image = love.graphics.newImage("assets/sheets/gun.png")
      self.image_n = love.graphics.newImage("assets/sheets/gun.png")
      self.sprite = light_world:newImage(self.image, self.x, self.y)
      self.sprite:setNormalMap(self.image_n)
      self.bullet_speed = 15
      self.projectiles = { }
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
