local x = 200
local y = 300
local r = 0 --track this in radians 0 to 2pi
local dr = 0
local dx = 0
local dy = 0
local direction = -1 --1 is left, -1 is right
local canFlip = true

local torqueStrength = 3
local acceleration = 50

local fuel = 1
local damages = 0
local lossTimer = 0

local playerColliderTop = CircleCollider:Create(x, y - 13, 11)
local playerColliderBottom = CircleCollider:Create(x, y + 13, 11)

function ResetPlayer()
	x = 200
	y = 300
	r = 0 
	dr = 0
	dx = 0
	dy = 0
	direction = -1 

	fuel = 1
	damages = 0
	lossTimer = 0
end

local function damage(amount) 
	damages = damages + amount / 10
end

local function CheckCollisions() 
	local spaceStationWinCollider = SpaceStationWinCollider()
	local winCollision = playerColliderTop:CircleCollision(spaceStationWinCollider) or playerColliderBottom:CircleCollision(spaceStationWinCollider)
	if (winCollision) then
		love.audio.stop(boosterAudio)
		love.audio.play(winAudio)
		extra = ""
		if damages == 0 then
			extra = "Without hurting yourself or the spaceship!"
		elseif damages < 1 then
			extra = "With minimal damages to you or the spaceship!"
		else
			extra = "But you cost the taxpayers $" .. string.format("%.2f", damages) .. " billion in damages"
		end
		EndGame(true, extra)
	end

	local spaceStationUnsafeColliders = SpaceStationUnsafeColliders()

	for index, col in ipairs(spaceStationUnsafeColliders) do
		if (col:CircleCollision(playerColliderTop)) then
			local xClose = math.max(col.x, math.min(col.x + col.w, playerColliderTop.center.x))
			local yClose = math.max(col.y, math.min(col.y + col.h, playerColliderTop.center.y))

			local phi = math.atan2(yClose - playerColliderTop.center.y, xClose - playerColliderTop.center.x)

			x = xClose - 13 * (math.sin(r) + math.cos(phi))
			y = yClose + 13 * (math.cos(r) - math.sin(phi))

			if (xClose == playerColliderTop.center.x) then
				damage(math.abs(dy))

				dy = -dy * .1
			elseif (yClose == playerColliderTop.center.y) then
				damage(math.abs(dx))

				dx = -dx * .1
			else 
				local phi2 = math.atan2(dy, dx)

				newdx = dx * math.cos((phi - phi2) * 2) + dy * math.sin((phi - phi2) * 2)
				newdy = -dx * math.sin((phi - phi2) * 2) + dy * math.cos((phi - phi2) * 2)

				dx = newdx * .5
				dy = newdy * .5

				damage(math.pow(math.pow(dx, 2) + math.pow(dy, 2), .5) / 4)
			end

			--love.audio.stop(hitAudio)
			love.audio.play(hitAudio)
		end
		if (col:CircleCollision(playerColliderBottom)) then
			local xClose = math.max(col.x, math.min(col.x + col.w, playerColliderBottom.center.x))
			local yClose = math.max(col.y, math.min(col.y + col.h, playerColliderBottom.center.y))

			local phi = math.atan2(yClose - playerColliderBottom.center.y, xClose - playerColliderBottom.center.x)

			x = xClose + 13 * (math.sin(r) - math.cos(phi))
			y = yClose - 13 * (math.cos(r) + math.sin(phi))

			if (xClose == playerColliderBottom.center.x) then
				damage(math.abs(dy))

				dy = -dy * .1
			elseif (yClose == playerColliderBottom.center.y) then
				damage(math.abs(dx))

				dx = -dx * .1
			else 
				local phi2 = math.atan2(dy, dx)

				newdx = dx * math.cos((phi - phi2) * 2) + dy * math.sin((phi - phi2) * 2)
				newdy = -dx * math.sin((phi - phi2) * 2) + dy * math.cos((phi - phi2) * 2)

				dx = newdx * .5
				dy = newdy * .5

				damage(math.pow(math.pow(dx, 2) + math.pow(dy, 2), .5) / 4)
			end

			--love.audio.stop(hitAudio)
			love.audio.play(hitAudio)
		end
	end

	local asteroidColliders = GetAsteroidColliders()

	for index, col in ipairs(asteroidColliders) do
		if (playerColliderTop:CircleCollision(col) or playerColliderBottom:CircleCollision(col)) then
			--if (not debug) then
				Lose()
			--end
		end
	end
end

function PlayerLoad()
	playerImage = love.graphics.newImage("Images/Astronaut.png")
	boosterAudio = love.audio.newSource("Sound/Booster.wav", "static")
	boosterAudio:setVolume(.1)

	hitAudio = love.audio.newSource("Sound/Hit.wav", "static")

	asteroidAudio = love.audio.newSource("Sound/Asteroid.wav", "static")
	asteroidAudio:setVolume(.25)

	winAudio = love.audio.newSource("Sound/Win.wav", "static")
	winAudio:setVolume(.15)
end

local boostingForward = false
local wasBoostingForward = false
local boostingCW = false
local wasBoostingCW = false
local boostingCCW = false
local wasBoostingCCW = false

function PlayerUpdate(dt) 

	if fuel > 0 then
		boosterAudio:setVolume(.1 * fuel)
		--spinning
		if (love.keyboard.isDown("right", "d")) then
			dr = dr + torqueStrength * dt

			NewBooster(x + 20 * math.cos(r - 5 * math.pi / 8), y + 20 * math.sin(r - 5 * math.pi / 8), math.cos(r), -math.sin(r))
			boostingCW = true

			fuel = fuel - dt / 15
		else
			boostingCW = false
		end
		if (love.keyboard.isDown("left", "a")) then
			dr = dr - torqueStrength * dt

			NewBooster(x + 20 * math.cos(r - 3 * math.pi / 8), y + 20 * math.sin(r - 3 * math.pi / 8), -math.cos(r), math.sin(r))
			boostingCCW = true

			fuel = fuel - dt / 15
		else
			boostingCCW = false
		end

		--print(dy)
		--moving
		if (love.keyboard.isDown("up", "w")) then
			dx = dx + math.sin(r) * acceleration * dt
			dy = dy - math.cos(r) * acceleration * dt

			if (direction == -1) then
				NewBooster(x + 13 * math.cos(r + 3 * math.pi / 4), y + 13 * math.sin(r + 3 * math.pi / 4), -10 * math.sin(r) + dx, 10 * math.cos(r) + dy)
			else
				NewBooster(x + 13 * math.cos(r + math.pi / 4), y + 13 * math.sin(r + math.pi / 4), -10 * math.sin(r) + dx, 10 * math.cos(r) + dy)
			end 
			boostingForward = true

			fuel = fuel - dt / 15
		else
			boostingForward = false
		end

		if (not love.keyboard.isDown("d", "right", "a", "left", "up", "w")) then
			love.audio.stop(boosterAudio)
		end

		if ((boostingForward and not wasBoostingForward) or (boostingCW and not wasBoostingCW) or (boostingCCW and not wasBoostingCCW)) then
			love.audio.stop(boosterAudio)
			love.audio.play(boosterAudio)
		end

		wasBoostingForward = boostingForward --this is so it will restart if another booster is started so as to get the loud start
		wasBoostingCW = boostingCW
		wasBoostingCCW = boostingCCW
	end

	--flipping across local y
	if (love.keyboard.isDown("r")) then
		if (canFlip) then
			direction = -direction
			canFlip = false
		end
	else 
		canFlip = true
	end 

	--velocity
	x = x + dx * dt
	y = y + dy * dt
	r = r + dr * dt

	--collisions
	playerColliderTop.center.x = x + 13 * math.sin(r)
	playerColliderTop.center.y = y - 13 * math.cos(r)
	playerColliderBottom.center.x = x - 13 * math.sin(r)
	playerColliderBottom.center.y = y + 13 * math.cos(r)

	CheckCollisions()

	--fuel
	if fuel <= 0 then
		fuel = 0
		lossTimer = lossTimer + dt

		if lossTimer > 3 then
			Lose()
		end
	end
end

function PlayerDraw()
	love.graphics.draw(playerImage, x, y, r, .5 * direction, .5, 27, 51.5)

	if (love.keyboard.isDown("up", "w")) then
		--create booster trail
	end

	if (debug) then
		playerColliderTop:Draw()
		playerColliderBottom:Draw()
	end
end

function GetFuel()
	return fuel
end

function GetDamages() 
	return damages
end

function Lose()
	love.audio.play(asteroidAudio)
	love.audio.stop(boosterAudio)
	extra = ""
	if damages ~= 0 then
		extra = "And you cost the taxpayers $" .. string.format("%.2f", damages) .. " billion in damages"
	else
		ran = math.floor(love.math.random() * 8)
		if ran == 0 then
			extra = "At least you didn't cost the taxpayers anything"
		elseif ran == 1 then
			extra = "You'll run out of oxygen soon though, don't worry"
		elseif ran == 2 then
			extra = "I hear space is lovely this time of year"
		elseif ran == 3 then
			extra = "You know you're supposed to get to the ship, right?"
		elseif ran == 4 then
			extra = "Years of academy training wasted!"
		elseif ran == 5 then
			extra = "Ground control to Major Tom"
		elseif ran == 6 then
			extra = "Just like the simulations"
		elseif ran == 7 then
			extra = "Too bad there is no easy mode"
		end
	end

	EndGame(false, extra)
end
