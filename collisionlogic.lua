CircleCollider = {}
CircleCollider.__index = CircleCollider

function CircleCollider:Create(xx, yy, rad) 
	local this = 
	{
		center = {x = xx, y = yy},
		radius = rad
	}
	setmetatable(this, self)
	return this
end

function CircleCollider:Draw() 
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.ellipse("line", self.center.x, self.center.y, self.radius)
	love.graphics.setColor(1, 1, 1, 1)
end

RectangleCollider = {}
RectangleCollider.__index = RectangleCollider

function RectangleCollider:Create(xx, yy, ww, hh)
	local this =
	{
		x = xx,
		y = yy,
		w = ww,
		h = hh
	}
	setmetatable(this, self)
	return this
end

function RectangleCollider:Draw()
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	love.graphics.setColor(1, 1, 1, 1)
end

function RectangleCollider:CircleCollision(cirCol) 
	local xClose = math.max(self.x, math.min(self.x + self.w, cirCol.center.x))
	local yClose = math.max(self.y, math.min(self.y + self.h, cirCol.center.y))

	local distanceSqr = math.pow(xClose - cirCol.center.x, 2) + math.pow(yClose - cirCol.center.y, 2)
	local radiusSqr = math.pow(cirCol.radius, 2)

	if (radiusSqr >= distanceSqr) then
		return true
	end

	return false
end

function CircleCollider:CircleCollision(cirCol) 
	local xDis = self.center.x - cirCol.center.x
	local yDis = self.center.y - cirCol.center.y

	local distanceSqr = math.pow(xDis, 2) + math.pow(yDis, 2)
	local radiusSqr = math.pow(self.radius + cirCol.radius, 2) 

	if (radiusSqr >= distanceSqr) then
		return true
	end

	return false
end

