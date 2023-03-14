-- this code replicates the bit32 library for Lua 5.4
-- generated by ChatGPT on March 13, 2023 (with tweaks and coaxing added)

local bit32 = {}

function bit32.band(...)
  local result = 0xFFFFFFFF
  for i = 1, select("#", ...) do
    result = result & select(i, ...)
  end
  return result & 0xFFFFFFFF
end

function bit32.bor(...)
  local result = 0
  for i = 1, select("#", ...) do
    result = result | select(i, ...)
  end
  return result & 0xFFFFFFFF
end

function bit32.bnot(n)
  return ~n & 0xFFFFFFFF
end

function bit32.bxor(...)
  local result = 0
  for i = 1, select("#", ...) do
    result = result ~ select(i, ...)
  end
  return result & 0xFFFFFFFF
end

function bit32.lshift(n, shift)
  return (n << shift) & 0xFFFFFFFF
end

function bit32.rshift(n, shift)
  return (n & 0xFFFFFFFF) >> shift
end

function bit32.arshift(n, shift)
  local sign = n & 0x80000000
  n = n >> shift
  if sign ~= 0 then
    -- If the original number was negative, set the leftmost bits to 1s
    n = n | ~(0xFFFFFFFF >> shift)
  end
  return n & 0xFFFFFFFF
end

function bit32.btest(...)
  return bit32.band(...) ~= 0
end

function bit32.extract(n, field, width)
  width = width or 1
  local mask = 2^width - 1
  return ((n >> field) & mask) & 0xFFFFFFFF
end

function bit32.replace(n, v, field, width)
  width = width or 1
  local mask = ~(2^(width + field) - 2^field)
  return ((n & mask) | ((v << field) & ~mask)) & 0xFFFFFFFF
end

function bit32.lrotate(n, shift)
  shift = shift & 31 -- equivalent to shift % 32
  local n32 = n & 0xFFFFFFFF
  return ((n32 << shift) | (n32 >> (32 - shift))) & 0xFFFFFFFF
end

function bit32.rrotate(n, shift)
  shift = shift & 31 -- equivalent to shift % 32
  local n32 = n & 0xFFFFFFFF
  return ((n32 >> shift) | (n32 << (32 - shift))) & 0xFFFFFFFF
end

return bit32
