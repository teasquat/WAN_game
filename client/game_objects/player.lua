local Player
do
  local _class_0
  local _base_0 = {
    add_gun = function(self, x, y, a)
      local Gun
      Gun = require("game_objects").Gun
      return table.insert(self.weapons, Gun(x, y, a))
    end,
    set_controls = function(self, left, right, jump)
      self.left, self.right, self.jump = left, right, jump
    end,
    draw = function(self)
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(self.image, self.x, self.y, 0, self.direction, 1, self.w / 2, self.h / 2)
      local _list_0 = self.weapons
      for _index_0 = 1, #_list_0 do
        local w = _list_0[_index_0]
        w:draw()
      end
    end,
    update = function(self, dt)
      if love.keyboard.isDown(self.left) then
        self.dx = self.dx - (self.acceleration * dt)
      end
      if love.keyboard.isDown(self.right) then
        self.dx = self.dx + (self.acceleration * dt)
      end
      self.dy = self.dy + (self.gravity * dt)
      self.dx = self.dx - ((self.dx / self.friction) * dt)
      self.dy = self.dy - ((self.dy / self.friction_v) * dt)
      self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)
      self.rect.x, self.rect.y = self.x, self.y
      self.sprite.x, self.sprite.y = self.x, self.y
      camera.x, camera.y = -self.x + love.graphics.getWidth() / 3, -self.y + love.graphics.getHeight() / 2
      self.grounded = false
      local _list_0 = self.cols
      for _index_0 = 1, #_list_0 do
        local v = _list_0[_index_0]
        if v.normal.y ~= 0 then
          if v.normal.y == -1 then
            self.grounded = true
          end
          self.dy = 0
        end
        if v.normal.x ~= 0 then
          self.dx = 0
        end
      end
      local temp_dir = math.sign(self.dx)
      if not (temp_dir == 0) then
        self.direction = temp_dir
      end
      local _list_1 = self.weapons
      for _index_0 = 1, #_list_1 do
        local w = _list_1[_index_0]
        w:update(self, self.direction)
      end
    end,
    press = function(self, key)
      if key == self.jump then
        if self.grounded then
          self.dy = -self.jump_height
        end
      elseif key == "lshift" then
        local _list_0 = self.weapons
        for _index_0 = 1, #_list_0 do
          local w = _list_0[_index_0]
          w:shoot(0)
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      self.x, self.y, self.w, self.h = x, y, w, h
      self.dx, self.dy = 0, 0
      self.friction = 0.1
      self.friction_v = 2
      self.acceleration = 35
      self.gravity = 50
      self.jump_height = 8.5
      self:set_controls("a", "d", "space")
      self.image = love.graphics.newImage("assets/sheets/player/naked.png")
      self.image_n = love.graphics.newImage("assets/sheets/player/naked_m.png")
      self.sprite = light_world:newImage(self.image, self.x, self.y)
      self.sprite:setNormalMap(self.image_n)
      self.rect = light_world:newRectangle(self.x, self.y, self.w, self.h)
      self.weapons = { }
      self.direction = -1
    end,
    __base = _base_0,
    __name = "Player"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Player = _class_0
  return _class_0
end
