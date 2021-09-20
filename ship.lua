Ship = Object:extend()

local speed = 3
local turn = 2
local outside = false

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

    self.angle = math.atan2(center.x - self.position.x , center.y - self.position.y)

    local stronger_direction = math.abs(math.cos(self.angle)) < math.abs(math.sin(self.angle)) and 'x' or 'y'

    if not outside then
      self.velocity[stronger_direction] = - self.velocity[stronger_direction]*0.8
      outside = true
    end

  else
    outside = false
    self:rotate(input.left, input.right, dt)
  end
  if input.go then self:accelerate(dt) end

  self.position = {
    x = self.position.x + self.velocity.x,
    y = self.position.y + self.velocity.y
  }
end

function Ship:draw()
  love.graphics.draw(
    self.sprite,
    self.position.x, self.position.y,
    self.angle + math.pi / 2,
    1, 1, --scale
    16, 16 --offset (half sprite)
  )
  love.graphics.line (
    self.position.x,
    self.position.y,
    self.position.x + math.cos(self.angle)*100,
    self.position.y + math.sin(self.angle)*100
  )
  -- love.graphics.circle('fill', self.position.x, self.position.y, 2)
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

function Ship:accelerate(dt)
  self.velocity = {
    x = self.velocity.x + math.cos(self.angle) * speed * dt,
    y = self.velocity.y + math.sin(self.angle) * speed * dt
  }
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
