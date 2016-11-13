# WAN_game
A online game, idk what

#Server
`luarocks install LuaSocket`

```moonscript
socket = require "socket"
udp = socket.udp!
ip = "127.1.1.1" --or whatever your server is
port = 7788

udp\settimeout 0
udp\setsockname ip, port

player_id = 123896

udp\send "move_{#player_id}_{#x}:{#y}:{#dx}:{#dy}"
udp\send "update__"
```
