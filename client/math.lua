math.lerp = function(a, b, dt)
  return (1 - t) * a + t * b
end
math.lerp2 = function(a, b, dt)
  return a + (b - a) * t
end
math.cerp = function(a, b, dt)
  local f = (1 - (math.cos(t * math.pi))) / 2
  return a * (1 - f) + b * f
end
