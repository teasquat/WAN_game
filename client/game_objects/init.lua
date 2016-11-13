local path = "game_objects/"
local Box = require(path .. "box")
local Player = require(path .. "player")
local Gun = require(path .. "gun")
return {
  Box = Box,
  Player = Player,
  Gun = Gun
}
