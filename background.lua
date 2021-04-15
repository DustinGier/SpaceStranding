local earthDayLength = 120
local earthTime = 0 --ratio of time of day between 0 and 1

local sunDayLength = 225
local sunTime = love.math.random() * 225

function BackgroundLoad()
	background = love.graphics.newImage("Images/Sky.png")
	earth = love.graphics.newImage("Images/Earth.png")
	moon = love.graphics.newImage("Images/Moon.png")
	sun = love.graphics.newImage("Images/Sun.png")
end

function BackgroundDraw() 
	love.graphics.draw(background, 0, 0, 0, 3, 3)

	if ((sunTime > .875 and sunTime < 1) or (sunTime > 0 and sunTime < .375)) then
		if (sunTime > .875 and sunTime <= 1) then
			love.graphics.setColor(0, 0, 0, (sunTime - .875) * 8)
		elseif (sunTime >= 0 and sunTime < .25) then
			love.graphics.setColor(0, 0, 0, 1)
		elseif (sunTime >= .25 and sunTime < 375) then
			love.graphics.setColor(0, 0, 0, (.375 - sunTime) * 8)
		end

		love.graphics.rectangle("fill", 0, 0, 1200, 675)
		love.graphics.setColor(1, 1, 1, 1)
	end 

	love.graphics.draw(earth, 600, 1100, earthTime * 2 * math.pi, 3, 3, 200, 200)

	love.graphics.draw(sun, 600 + 900 * math.sin(sunTime * 2 * math.pi - .25 * math.pi), 700 - 600 * math.cos(sunTime * 2 * math.pi - .25 * math.pi), 0, .35, .35, 200, 200)
	love.graphics.draw(moon, 600 - 900 * math.sin(sunTime * 2 * math.pi), 700 + 600 * math.cos(sunTime * 2 * math.pi), 0, .7, .7, 100, 100)
end

function BackgroundUpdate(dt) 
	earthTime = earthTime + dt / earthDayLength
	earthTime = earthTime % 1

	sunTime = sunTime + dt / sunDayLength
	sunTime = sunTime % 1
end
