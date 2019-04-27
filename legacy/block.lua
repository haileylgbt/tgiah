block = { }
-- resources:
block.graphic = {
	brick = love.graphics.newImage('brick.png'),
	dirt = love.graphics.newImage('dirt.png'),
	grass = love.graphics.newImage('grass.png'),
	lava = love.graphics.newImage('lava.png'),
	door = love.graphics.newImage('door.png'),
	box = love.graphics.newImage('box.png'),
	box2 = love.graphics.newImage('box2.png')
}
-- condition functions:
function block.solid(which) return which.solid end
function block.deadly(which) return which.deadly end
function block.win(which) return which.win end
-- default drawing behaviour:
function block.draw(x, y, block, ox, oy)
	love.graphics.draw(block.graphic, x * level.gridw + ox, y * level.gridh + oy)
end
-- offset drawing behaviour:
function block.drawOffset(x, y, block, ox, oy)
	love.graphics.draw(block.graphic,
		x * level.gridw + ox + block.ofsX,
		y * level.gridh + oy + block.ofsY)
end
-- 16-frame animated block:
block.anim16 = { }
function block.anim16.update(x, y, this, dt)
	this.frame = (this.frame + this.speed * dt) % 16
end
function block.anim16.draw(x, y, this, ox, oy)
	love.graphics.draw(this.graphic,
		block.anim16.quad[math.floor(this.frame)],
		x * level.gridw + ox, y * level.gridh + oy)
end

-- custom block functions:
block.toggle = { }
function block.toggle.update(x, y, this, dt)
	this.timer = this.timer + dt
	if (this.timer >= 1) then
		this.timer = 0
		if (this.draw) then
			love.graphics.clear()
			this.draw = nil
			this.solid = false
		else
			this.draw = block.draw
			this.solid = true
		end
	end
end
function block.init()
	local i
	-- generate animated block quads:
	block.anim16.quad = { }
	for i = 0, 15 do
		block.anim16.quad[i] = love.graphics.newQuad(
			(i % 4) * 32,
			math.floor(i / 4) * 32,
			32, 32, 128, 128)
	end
end
block.init()
