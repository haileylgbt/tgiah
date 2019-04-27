-- Grid-based platformer game engine (and example)
-- by YellowAfterlife
-- version 1.0.5, 15/03/2012
-- Actually usable for any grid-based games
require 'trace'
require 'waskey'
require 'level'
require 'harriet'
require 'coin'
require 'block'
require 'stages'

-- block definitions:
blocks = {
	brick = {
		solid = true,
		draw = block.draw,
		graphic = block.graphic.brick},
	dirt = {
		solid = true,
		draw = block.draw,
		graphic = block.graphic.dirt},
	grass = {
		solid = true,
		draw = block.draw,
		graphic = block.graphic.grass},
	lava = {
		deadly = true,
		graphic = block.graphic.lava,
		update = block.anim16.update,
		draw = block.anim16.draw,
		frame = 0,
		speed = 11.6},
	door = {
		win = true,
		draw = block.drawOffset,
		graphic = block.graphic.door,
		ofsX = -4, ofsY = -4},
	toggle1 = {
		update = block.toggle.update,
		timer = 0,
		graphic = block.graphic.box2},
	toggle2 = {
		update = block.toggle.update,
		timer = 1,
		graphic = block.graphic.box},
}
-- rules for loading levels from string
level.rules = {
	{ ' ' },
	{ 'x', 0, blocks.brick },
	{ 'd', 0, blocks.dirt },
	{ 'g', 0, blocks.grass },
	{ 'l', 0, blocks.lava },
	{ 'w', 0, blocks.door },
	{ 't', 0, blocks.toggle1 },
	{ 'T', 0, blocks.toggle2 },
	{ 'p', 1, harriet },
	{ 'c', 1, coin }
}

function love.update(dt)
	level.update(dt)
	love.keyboard.updateKeys()

	if love.keyboard.isDown("j") then
		if love.keyboard.isDown("e") then
			if love.keyboard.isDown("s") then
				if love.keyboard.isDown("s") then
					harriet.jumps = 999
					harriet.graphic = love.graphics.newImage('jess.png')
					love.window.setTitle("This Game Is About Jess")
				end
			end
		end
	end
end

function love.draw()
	local w, h
	w = level.width * level.gridw
	h = level.height * level.gridh

	--[[

	race.print('TGIAH v1.0', trace.styles.green)
	trace.print('Running on ' .. tostring(_VERSION), trace.styles.green)
	trace.print('Jumps: ' .. tostring(harriet.jumps), trace.styles.blue)
	trace.print('by Harry', trace.styles.yellow)

	]]--

	love.graphics.setColor(0, 255, 255, 255)
	love.graphics.rectangle('fill', -3 - level.x, -3 - level.y, w + 6, h + 6)
	love.graphics.printf(tostring(level.name), -level.x, -level.y + h + 4, w, 'center')
	love.graphics.setColor(63, 63, 63, 255)
	love.graphics.rectangle('fill', -2 - level.x, -2 - level.y, w + 4, h + 4)
	love.graphics.setColor(255, 240, 127, 255)
	love.graphics.printf(tostring(harriet.jumps), -level.x - 3, -level.y + h + 4, w + 6, 'left')
	love.graphics.setColor(255, 127, 127, 255)
	love.graphics.printf(tostring(deaths), -level.x - 3, -level.y + h + 4, w + 6, 'right')
	level.draw()
	trace.draw()
end

function love.load()
	love.window.setTitle("This Game Is About Harriet")
	score = 0
	love.graphics.setBackgroundColor(0, 0, 0)
	deaths = 0
	level.current = 0
	level.next()
end
