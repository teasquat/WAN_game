local path = "game_objects/"
local Box = require(path .. "box")
local Player = require(path .. "player")
local Gun = require(path .. "gun")
local Friend = require(path .. "friend")
return {
  Box = Box,
  Player = Player,
  Gun = Gun,
  Friend = Friend
}
