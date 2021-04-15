local screen = 0 --0 start, 1 in game, 2 end, 3 controls

local selectedButton = -1 -- -1 for none, 1 for play, 2 controls, 3 leave controls, 4 return to menu
local previouslySelected = -1

local won = false
local extraText = ""

function ScreensLoad()
	nasaFontBig = love.graphics.newFont("Font/nasalization-rg.ttf", 72)

	nasaFontSmall = love.graphics.newFont("Font/nasalization-rg.ttf", 32)

	selectionAudio = love.audio.newSource("Sound/Selection.wav", "static")
	selectionAudio:setVolume(.5)

	pressedAudio = love.audio.newSource("Sound/Pressed.wav", "static")
end

function ScreensUpdate(dt)
	mX = love.mouse.getX()
	mY = love.mouse.getY()

	mouseClick = love.mouse.isDown(1, 2)

	if (screen == 0) then
		if (mX >= 200 and mX < 290 and mY > 280 and mY < 312) then
			selectedButton = 1
		elseif (mX > 840 and mX < 1030 and mY > 280 and mY < 312) then
			selectedButton = 2
		else 
			selectedButton = -1
		end

		if (mouseClick) then
			if (selectedButton == 2) then
				screen = 3
			elseif selectedButton == 1 then
				ResetPlayer()
				ClearBoosters()
				ClearAsteroids()
				PopulateAsteroids()
				screen = 1
			end
		end
	elseif (screen == 2) then
		if (mX > 550 and mX < 650 and mY > 470 and mY < 502) then
			selectedButton = 4
		else
			selectedButton = -1
		end

		if (selectedButton == 4 and mouseClick) then
			screen = 0
		end
	elseif (screen == 3) then
		if (mX > 570 and mX < 650 and mY > 430 and mY < 462) then
			selectedButton = 3
		else 
			selectedButton = -1
		end

		if (selectedButton == 3 and mouseClick) then
			screen = 0
		end
	end

	if (love.keyboard.isDown("escape")) then
		screen = 0
	end

	if (selectedButton ~= previouslySelected and selectedButton ~= -1) then
		love.audio.play(selectionAudio)
	end

	previouslySelected = selectedButton

	if (selectedButton ~= -1 and mouseClick) then
		love.audio.play(pressedAudio)
	end
end

local function SetSelectedColor(selected) 
	if (selected) then
		love.graphics.setColor(0, 1, 0, 1)
	else
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function ScreensDraw() 
	if (screen == 0) then
		love.graphics.print("SPACE STRANDING", nasaFontBig, 240, 50)

		SetSelectedColor(selectedButton == 1)
		love.graphics.print("PLAY", nasaFontSmall, 225, 280)
		SetSelectedColor(selectedButton == 2)
		love.graphics.print("CONTROLS", nasaFontSmall, 840, 280)
	elseif (screen == 1) then
		love.graphics.print("FUEL:", nasaFontSmall, 860, 20)
		love.graphics.rectangle("line", 975, 24, 200, 32)
		love.graphics.rectangle("fill", 975, 24, 200 * GetFuel(), 32)

		love.graphics.print("DAMAGES: $" .. string.format("%.2f", GetDamages()) .. " billion", nasaFontSmall, 20, 20)
	elseif (screen == 2) then
		if won then
			love.graphics.print("YOU'RE NOT STUCK IN ORBIT\n\t\t\t\t  FOREVER", nasaFontBig, 70, 30)
		else
			love.graphics.print("YOU'RE STUCK IN ORBIT\n\t\t\tFOREVER", nasaFontBig, 190, 30)
		end

		love.graphics.print(extraText, nasaFontSmall, 600 - 8.5 * string.len(extraText), 410)

		SetSelectedColor(selectedButton == 4)
		love.graphics.print("MENU", nasaFontSmall, 550, 470)
	elseif (screen == 3) then 
		love.graphics.print("CONTROLS", nasaFontBig, 10, 260)
		love.graphics.print("W - Boost\nA - Rotate CCW\nD - Rotate CW\nR - Flip Astronaut\nEscape - Main Menu\n\nReach the hatch\non the spaceship\n\nDon't hit asteroids", 
			nasaFontSmall, 800, 105)

		SetSelectedColor(selectedButton == 3)
		love.graphics.print("EXIT", nasaFontSmall, 570, 430)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

function EndGame(w, extra)
	screen = 2
	won = w
	extraText = extra
end

function GetInGame()
	return screen == 1
end
