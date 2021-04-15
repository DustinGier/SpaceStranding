local asteroids = {}

function AsteroidsLoad()
	asteroidImage = love.graphics.newImage("Images/Asteroid.png")
end

Asteroid = {}
Asteroid.__index = Asteroid

function Asteroid:Create(sizeS, xx, yy, dxx, dyy, drr)
	local this = 
	{
		size = sizeS,
		x = xx,
		y = yy,
		dx = dxx,
		dy = dyy,
		r = 0,
		dr = drr,
		col = CircleCollider:Create(xx, yy, size * 32)
	}
	setmetatable(this, self)
	return this
end

function Asteroid:Update(dt) 
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	self.col.center.x = self.x
	self.col.center.y = self.y

	self.r = self.r + self.dr * dt
end

function Asteroid:Draw() 
	love.graphics.draw(asteroidImage, self.x, self.y, self.r, self.size, self.size, 50, 50)

	if (debug) then
		self.col:Draw()
	end
end

function AsteroidsUpdate(dt) 
	if (love.math.random() < dt / 1.5) then
		asteroids[table.getn(asteroids) + 1] = NewAsteroid()
	end

	for index, ast in ipairs(asteroids) do
		ast:Update(dt)

		if (ast.x < -100 or ast.x > 1300 or ast.y < -100 or ast.y > 775) then
			table.remove(asteroids, index)			
		end
	end
end

function AsteroidsDraw() 
	for index, ast in ipairs(asteroids) do
		ast:Draw()
	end
end

function NewAsteroid() 
	size = .08 * math.ceil(love.math.random() * 8 + 2)
	speed = 20
	minspeed = 20
	location = love.math.random()
	if (location < .25) then --left side of screen
		x = -100
		y = love.math.random() * 875 - 100
		dx = love.math.random() * speed + minspeed
		dy = love.math.random() * speed + minspeed
		if (y - 375 > 0) then
			dy = -dy
		end
	elseif (location >= .25 and location < .5) then --right side
		x = 1300
		y = love.math.random() * 875 - 100
		dx = -love.math.random() * speed - minspeed
		dy = love.math.random() * speed + minspeed
		if (y - 375 > 0) then
			dy = -dy
		end
	elseif (location >= .5 and location < .75) then --top
		y = -100
		x = love.math.random() * 1400 - 100
		dy = love.math.random() * speed + minspeed
		dx = love.math.random() * speed + minspeed
		if (x - 600 > 0) then
			dx = -dx
		end
	else --bottom
		y = 750
		x = love.math.random() * 1400 - 100
		dy = -love.math.random() * speed - minspeed
		dx = love.math.random() * speed + minspeed
		if (x - 600 > 0) then
			dx = -dx
		end
	end

	dr = love.math.random() - .5

	return Asteroid:Create(size, x, y, dx, dy, dr)
end

function ClearAsteroids() 
	for index, ast in ipairs(asteroids) do
		asteroids[index] = nil 
	end
end

function PopulateAsteroids()
	for i=1,20 do
		asteroids[i] = NewAsteroid()
	end
end

function GetAsteroidColliders()
	ret = {}

	for index, ast in ipairs(asteroids) do
		ret[index] = ast.col
	end

	return ret
end