Ship = Object:extend()

local speed = 3
local turn = 2

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

function Ship:update(input, dt)
  self:rotate(input.left * dt, input.right * dt)

  if input.go == 1 then self:accelerate(dt) end

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
    .5, .5, --scale
    16, 16 --offset
  )
  -- love.graphics.circle('fill', self.position.x, self.position.y, 2)
end

function Ship:rotate(left, right)
  self.angle = self.angle + ((right - left) * turn)
  self.angle = self.angle % (2 * math.pi)
end

function Ship:accelerate(dt)
  self.velocity = {
    x = self.velocity.x + math.cos(self.angle) * speed * dt,
    y = self.velocity.y + math.sin(self.angle) * speed * dt
  }
end
