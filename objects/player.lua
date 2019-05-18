Player = {}

require "tools/camera"
require "tools/physics_helper"
require "world_physics/world_physics"

local rect = require "objects/rect"
local floor = math.floor

local tiles = tlm.tiles[3]



local quad  = love.graphics.newQuad
local anim_data = {
	quad(0,0,74,148,1280,148),
	quad(75,0,74,148,1280,148),
	quad(75*2,0,74,148,1280,148),
	quad(75*3,0,74,148,1280,148),
	quad(75*4,0,74,148,1280,148),
}
local image = love.graphics.newImage("assets/images/harriet.png")
image:setFilter("nearest","nearest")

function Player:new(x,y)

	--x,y,w,h,img,quad,id
	local player = require("objects/entity"):new(x,y,8,16,nil,nil,"harriet")

	function player:load()
		gameLoop:addLoop(self)
		renderer:addRenderer(self)

		init_physics(self,500)

		-- rem
		self.animation = require("tools/animation"):new(
				image,
				{
					{ -- idle
						anim_data[1]
					},
					{ -- walk right
						anim_data[2],
						anim_data[3]
					},
					{ -- walk left
						anim_data[4],
						anim_data[5]
					},
				},
				0.2
			)

		self.animation:play()
		-- end rem
	end

	local key = love.keyboard.isDown

	function player:die(type)
		player.pos.x = 80
		player.pos.y = 95
		self.vel.x = 0
		self.vel.y = 0
	end

	function player:tick(dt)
		camera:goto_point(self.pos)

		self.animation:set_animation(1)

		-- apply gravity
		apply_gravity(self,dt)

		if key("r") then
			player:die()
		end

		if key("lctrl") then
			self.vel.y = 10
		end

		if key("i") then
			self.on_ground = true
		end

		if key("left") then
			self.animation:set_animation(3)
			self.dir.x = -1
			if key("lshift") then
				self.vel.x = 300
			elseif key("lctrl") then
				self.vel.x = 50
				self.vel.y = 10
			else
				self.vel.x = 200
			end
		end

		if key("right") then
			self.animation:set_animation(2)
			self.dir.x = 1
			if key("lshift") then
				self.vel.x = 300
			elseif key("lctrl") then
				self.vel.x = 50
				self.vel.y = 10
			else
				self.vel.x = 200
			end
		end

		-- collisions
		update_physics(self,tiles,dt)
		--

		if key("up") then
			physics_jump(self)
		end

		self.pos.x = self.pos.x + (self.vel.x * dt) * self.dir.x
		self.pos.y = self.pos.y + (self.vel.y * dt) * self.dir.y

		self.vel.x = self.vel.x * (1-dt*12)

		self.animation:update(dt)
	end

	function player:draw()

		self.animation:draw({self.pos.x,self.pos.y},0,0.11,0.11)
		--love.graphics.rectangle("fill",self.pos.x,self.pos.y,self.size.x,self.size.y)
	end

	return player
end

return Player
