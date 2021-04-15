--boosters is shorthand for the trail of fuel that is sent from the player

local boosters = {}

Booster = {}
Booster.__index = Booster

function Booster:Create(xx, yy, dxx, dyy, sizeS, alphaA)
	local this =
	{
		x = xx,
		y = yy,
		dx = dxx,
		dy = dyy,
		size = sizeS,
		alpha = alphaA
	}
	setmetatable(this, self)

	return this
end

function Booster:Update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	self.alpha = self.alpha - dt
end

function Booster:Draw()
	love.graphics.setColor(.8, .8, .8, self.alpha)

	love.graphics.ellipse("fill", self.x, self.y, self.size, self.size)

	love.graphics.setColor(1, 1, 1, 1)
end

function BoostersUpdate(dt)
	for index, boost in ipairs(boosters) do
		boost:Update(dt)

		if (boost.alpha < 0) then
			table.remove(boosters, index)
		end
	end
end


function BoostersDraw()
	for index, boost in ipairs(boosters) do
		boost:Draw()
	end
end

function NewBooster(x, y, dx, dy)
	dx = dx * (love.math.random() / 10 + .95)
	dy = dy * (love.math.random() / 10 + .95)
	boosters[table.getn(boosters) + 1] = Booster:Create(x, y, dx, dy, love.math.random() * 2 + 1, love.math.random() / 2 + .5)
end

function ClearBoosters() 
	for index, boost in ipairs(boosters) do
		boosters[index] = nil
	end
end
