love.keyboard.keysPressed = { }
love.keyboard.keysReleased = { }
-- returns if specified key was pressed since the last update
function love.keyboard.wasPressed(key)
	if (love.keyboard.keysPressed[key]) then
		return true
	else
		return false
	end
end
-- returns if specified key was released since last update
function love.keyboard.wasReleased(key)
	if (love.keyboard.keysReleased[key]) then
		return true
	else
		return false
	end
end
-- concatenate this to existing love.keypressed callback, if any
function love.keypressed(key, unicode)
	love.keyboard.keysPressed[key] = true
end
-- concatenate this to existing love.keyreleased callback, if any
function love.keyreleased(key)
	love.keyboard.keysReleased[key] = true
end
-- call in end of each love.update to reset lists of pressed\released keys
function love.keyboard.updateKeys()
	love.keyboard.keysPressed = { }
	love.keyboard.keysReleased = { }
end
