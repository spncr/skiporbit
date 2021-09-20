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

local camera = Gamera.new(0, 0, 10000, 10000)

function love.load()
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  camera:setScale(2)

  ship = Ship()
end

function love.update(dt)
  input:update()
  ship:update(
    {
      left = input:get 'left',
      right = input:get 'right',
      go = input:get 'go'
    },
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
  local background = love.graphics.newImage('stars.jpg')
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
