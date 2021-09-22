Object = require 'libraries.classic.classic'
Baton = require 'libraries.baton.baton'
Gamera = require 'libraries.gamera.gamera'

require 'ship'

local input = Baton.new {
  controls = {
    left = {'key:left', 'key:a'},
    right = {'key:right', 'key:d'},
    go = {'key:space'},
  }
}

local camera = Gamera.new(0, 0, 100000, 100000)
local world = {}
local background = love.graphics.newImage('stars.jpg')

function love.load()
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  world.l, world.t, world.w, world.h = camera:getWorld()
  ship = Ship()
end

function love.update(dt)
  input:update()
  ship:update(
    {
      left = input:down 'left',
      right = input:down 'right',
      go = input:down 'go'
    },
    world,
    dt
  )

  camera:setPosition(ship.position.x, ship.position.y)
end

function love.draw()
  camera:draw(function (l,t,w,h)
    tiledBackgroundDraw()
    ship:draw()
  end)
end

function tiledBackgroundDraw()
  love.graphics.setColor(1, 1, 1, .6)

  local bg_width, bg_height = background:getDimensions() -- width, height
  local left, top, width, height = camera:getWorld()
  local x_reps = math.ceil(width / bg_width)
  local y_reps = math.ceil(height / bg_height)

  for i = 0, x_reps - 1 do
    for j = 0, y_reps - 1 do
      x = left + (i * bg_width)
      y = top + (j * bg_height)
      love.graphics.draw(background, x, y )
    end
  end
end

function sign(number)
  return number > 0 and 1
     or  number < 0 and -1
     or  0
end

function approach(start, goal, shift)
  return start < goal and math.min(start + shift, goal) or math.max(start - shift, goal)
end
