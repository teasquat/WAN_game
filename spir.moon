--Starts in highest, upper left corner.
args={...}

with turtle
  spiral_inwards = (length)  ->
    for l=length, 0, -1
      .digForward!
      .forward!
    .turnRight!
    for l=length, 0, -1
      .digForward!
      .forward!
    spiral_inwards length-1

  spiral_outwards = (length) ->
    for l=length, 0, -1
      .digForward!
      .forward!
    .turnRight!
    for l=length, 0, -1
      .digForward!
      .forward!
    spiral_inwards length+1

    make_cube = (width, height) ->
      for h=height, 0, -1
        if h%2==1
          spiral_inwards width
        else
          spiral_outwards width

  make_cube (tonumber args[1]), (tonumber args[2])
