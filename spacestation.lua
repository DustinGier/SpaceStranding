local unsafeColliders = {}

local winCollider = nil

function StationLoad()
	ssImage = love.graphics.newImage("Images/Spaceship.png")
	pointerImage = love.graphics.newImage("Images/Pointer.png")

	unsafeColliders[1] = RectangleCollider:Create(461, 202, 27, 61)
	unsafeColliders[2] = RectangleCollider:Create(428, 272, 145, 54)
	unsafeColliders[3] = RectangleCollider:Create(461, 333, 27, 63)
	unsafeColliders[4] = RectangleCollider:Create(520, 312, 36, 79)
	unsafeColliders[5] = RectangleCollider:Create(497, 355, 82, 17)
	unsafeColliders[6] = RectangleCollider:Create(630, 272, 132, 40)
	unsafeColliders[7] = RectangleCollider:Create(710, 202, 27, 61)
	unsafeColliders[8] = RectangleCollider:Create(713, 318, 30, 80)
	unsafeColliders[9] = RectangleCollider:Create(652, 205, 36, 75)

	winCollider = CircleCollider:Create(602, 295, 25)
end

local time = 3 * math.pi / 2

function StationDraw()
	love.graphics.draw(ssImage, 600, 300, 0, .5, .5, 500, 200)

	if (GetInGame()) then
		time = time + love.timer.getDelta() * 2
		time = time % (2 * math.pi)

		love.graphics.draw(pointerImage, 602, 250 - 7 * math.sin(time), 0, .5, -.5, 25, 25)
		love.graphics.draw(pointerImage, 602, 340 + 7 * math.sin(time), 0, .5, .5, 25, 25)
	end

	if (debug) then
		for index, col in ipairs(unsafeColliders) do
			col:Draw()
		end

		winCollider:Draw()
	end
	-- if (debug) then
	-- 	love.graphics.setColor(0, 1, 0)
	-- 	love.graphics.rectangle("line", 461, 202, 27, 61)
	-- 	love.graphics.rectangle("line", 428, 272, 145, 54)
	-- 	love.graphics.rectangle("line", 461, 333, 27, 63)
	-- 	love.graphics.rectangle("line", 520, 312, 36, 79)
	-- 	love.graphics.rectangle("line", 497, 355, 82, 17)
	-- 	love.graphics.rectangle("line", 630, 272, 132, 40)
	-- 	love.graphics.rectangle("line", 710, 202, 27, 61)
	-- 	love.graphics.rectangle("line", 713, 318, 30, 80)
	-- 	love.graphics.rectangle("line", 652, 205, 36, 75)

	-- 	love.graphics.ellipse("line", 602, 295, 25, 25)
	-- 	love.graphics.setColor(1, 1, 1)
	-- end
end

function SpaceStationUnsafeColliders() 
	return unsafeColliders
end

function SpaceStationWinCollider()
	return winCollider
end