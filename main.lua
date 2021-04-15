require "background"
require "collisionlogic"
require "boosters"
require "player"
require "spacestation"
require "screens"
require "asteroid"

debug = false
if (debug) then
	io.stdout:setvbuf("no")
end

function love.load() 
	love.window.setMode(1200, 675)
	love.window.setIcon(love.image.newImageData("Images/Earth.png"))
	love.window.setTitle("Space Stranding")

	muzak = love.audio.newSource("Sound/Muzak.wav", "static")
	muzak:setVolume(.25)

	ScreensLoad()
	BackgroundLoad()
	PlayerLoad()
	StationLoad()
	AsteroidsLoad()
end

function love.draw() 
	BackgroundDraw()
	StationDraw()
	ScreensDraw()
	if GetInGame() then
		PlayerDraw()
		BoostersDraw()
		AsteroidsDraw()
	end
	
end

function love.update(dt)
	love.audio.play(muzak)

	BackgroundUpdate(dt)
	ScreensUpdate(dt)

	if GetInGame() then
		PlayerUpdate(dt)
		AsteroidsUpdate(dt)
		BoostersUpdate(dt)
	end
end

--todo
--Sounds/Music