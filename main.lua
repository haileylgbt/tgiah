-- I would like to thank SkyVaultGames for guiding me through the process thanks to his YouTube series. <3


tlm 		= require "tools/tlm"

gameLoop 	= require "tools/gameLoop"
renderer 	= require "tools/renderer"
obm 		= require "tools/obm"
asm 		= require "tools/asm"

Width 		= love.graphics.getWidth()
Height      = love.graphics.getHeight()
key = love.keyboard.isDown

camera = require "tools/camera"

GAMETIME  = 0
TILE_SIZE = 16
MAP_SIZE_WIDTH  = 128
MAP_SIZE_HEIGHT  = 64

local delta_time = {}
local av_dt      = 0.016
local sample     = 10

function love.load()
	asm:load()
	asm:add(love.graphics.newImage("assets/images/tile_sheet_1.png"),"tiles")
	asm:add(love.audio.newSource("assets/audio/music/mus_belief.wav", "stream"), "bgm")
	gameLoop:load()
	renderer:load()
	tlm:load()
	obm:load()

	tlm:loadmap("harriet_playzone")

	camera.scale.x = 0.3
	camera.scale.y = 0.3

	obm:add(require("objects/player"):new(map.properties.spawn_x,map.properties.spawn_y))
end

local pop, push = table.remove,
			      table.insert

function love.update(dt)



	push(delta_time,dt)
	if #delta_time > sample then
		local av 	= 0
		local num 	= #delta_time

		for i = #delta_time,1,-1 do
			av = av + delta_time[i]
			pop(delta_time,i)
		end

		av_dt = av / num
	end

	gameLoop:update(av_dt)
	GAMETIME = GAMETIME + av_dt

end

function love.draw()
	love.graphics.reset()
	camera:set()
	renderer:draw()
	camera:unset()
	love.graphics.setBackgroundColor(1, 1, 1, 1)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("this is a test build, not the final game. a lot of things are expected to change, including the placeholder character.", 0, 0, 0, 1, 1)
end
