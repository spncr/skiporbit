Ship = Object:extend()
Exhaust = Object:extend()


local speed = 3 --rate
local turn = 4
local power = 6
local outside = false

local minCharge = 2
local charge = minCharge
local maxCharge = 8

local exhausts = {}


function Ship:new()
  self.sprite = love.graphics.newImage('ship.png')

  self.position = {
    x = 100,
    y = 100
  }
  self.angle = 0

  self.velocity = {
    x = 0,
    y = 0
  }
end

function Ship:update(input, world, dt)
  if ship:outside(world.l, world.t, world.w, world.h) then
    local center = {
      x = world.l + world.w/2,
      y = world.t + world.h/2
    }

    local angle = math.atan2(center.x - self.position.x, center.y - self.position.y)

    local stronger_direction = math.abs(math.cos(angle)) < math.abs(math.sin(angle)) and 'x' or 'y'

    if not outside then
      self.velocity[stronger_direction] = - self.velocity[stronger_direction]*0.8
      outside = true
    end

  else
    outside = false
    self:rotate(input.left, input.right, dt)
  end

  if input.go then
    charge = math.min(charge + power * dt, maxCharge)
  elseif charge > minCharge then
    self.velocity = {
      x = self.velocity.x + math.cos(self.angle) * charge^1.2,
      y = self.velocity.y + math.sin(self.angle) * charge^1.2
    }
    table.insert(exhausts, Exhaust(
      self.position,
      {x = -self.velocity.x, y = -self.velocity.y},
      charge*2
    ))
    charge = minCharge
  else
    --decay
    self.velocity = {
      x = approach(self.velocity.x,0,dt),
      y = approach(self.velocity.y,0,dt)
    }
  end
  -- if input.go then self:accelerate(dt) end

  self.position = {
    x = self.position.x + self.velocity.x,
    y = self.position.y + self.velocity.y
  }

  for key, exhaust in ipairs(exhausts) do
    if exhaust.radius <= 0 then
      table.remove(exhausts, key)
    else
      exhaust:update(dt)
    end
  end
end

function Ship:draw()
  local x_mag = math.cos(self.angle)
  local y_mag = math.sin(self.angle)
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.draw(
    self.sprite,
    self.position.x, self.position.y,
    self.angle + math.pi / 2,
    1, 1, --scale
    16, 16 --offset (half sprite)
  )

  -- charge
  love.graphics.setColor(.8, .3, .1, .6)
  love.graphics.circle(
    'fill',
    self.position.x - x_mag*16,
    self.position.y - y_mag*16,
    charge * 1.4
  )
  -- aim indicator for debugging
  love.graphics.setColor(1, 1, 1, .2)

  love.graphics.line (
    self.position.x,
    self.position.y,
    self.position.x + x_mag * 100,
    self.position.y + y_mag * 100
  )
  -- love.graphics.circle('fill', self.position.x, self.position.y, 2)


  for _, exhaust in ipairs(exhausts) do
    exhaust:draw()
  end
end

function Ship:rotate(left, right, dt)
  local deltaTurn = turn * dt
  if left and not right then
    self.angle = self.angle - deltaTurn
  elseif right and not left then
    self.angle = self.angle + deltaTurn
  end
  -- self.angle = self.angle + ((right - left) * turn)

  self.angle = self.angle % (2 * math.pi)
end

function Ship:outside(l, t, w, h)
  if (
    self.position.x < l or
    self.position.x > l + w or
    self.position.y < t or
    self.position.y > t + h
  ) then
    return true
  end
  return false
end

function Exhaust:new(position, velocity, radius)
  self.x = position.x
  self.y = position.y
  self.velocity = velocity
  self.radius = radius
end

function Exhaust:update(dt)
  self.x = self.x + self.velocity.x
  self.y = self.y + self.velocity.y
  self.radius = self.radius - 10 * dt
end

function Exhaust:draw()
  love.graphics.setColor(.8, .3, .1, .6)
  love.graphics.circle(
    'fill',
    self.x,
    self.y,
    self.radius
  )
end
