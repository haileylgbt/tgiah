require "coin"

harriet = {
	jumps = 3,
	graphic = love.graphics.newImage('harriet.png')
}
function harriet.create(this, px, py)
	-- dimensions:
	this.x = px + 6
	this.y = py + 6
	this.width = 20
	this.height = 20
	-- original position:
	this.xstart = this.x
	this.ystart = this.y
	-- movement:
	this.vspeed = 0
	this.gravity = 600
	this.jump = 350
	this.walk = 200

end
function harriet.update(this, dt)
	local i, j, k, m, stuck
	-- detect if stuck in a solid, thus should not move
	stuck = level.check(this.x, this.y, this.width, this.height, block.solid)
	-- horizontal speed:
	this.hspeed = 0
	if (love.keyboard.isDown('right')) then this.hspeed = this.walk end
	if (love.keyboard.isDown('left')) then this.hspeed = -this.walk end
	-- vertical speed:
	if (level.check(this.x, this.y + 1, this.width, this.height, block.solid)) then
		if (love.keyboard.isDown('up') and harriet.jumps > 0) then
			this.vspeed = -this.jump
			harriet.jumps = harriet.jumps - 1
		end
	else -- in air
		this.vspeed = this.vspeed + this.gravity * dt
	end
	-- horizontal movement:
	if (not stuck and this.hspeed ~= 0) then
		m = level.gridw
		i = math.abs(this.hspeed) * dt
		if this.hspeed > 0 then k = 1 else k = -1 end
		while (i > 0) do
			if (i < m) then j = i else j = m end
			if (not level.check(this.x + k * j, this.y, this.width, this.height, block.solid)) then
				this.x = this.x + k * j
			else
				if k > 0 then
					this.x = math.floor((this.x + this.width + j) / m) * m - this.width
				else
					this.x = math.floor(this.x / m) * m
				end
				this.hspeed = 0
				break
			end
			i = i - m
		end
	end
	-- vertical movement:
	if (not stuck and this.vspeed ~= 0) then
		m = level.gridh
		i = math.abs(this.vspeed) * dt
		if this.vspeed > 0 then k = 1 else k = -1 end
		while (i > 0) do
			if (i < m) then j = i else j = m end
			if (not level.check(this.x, this.y + k * j, this.width, this.height, block.solid)) then
				this.y = this.y + k * j
			else
				if k > 0 then
					this.y = math.floor((this.y + this.height + j) / m) * m - this.height
				else
					this.y = math.floor(this.y / m) * m
				end
				this.vspeed = 0
				break
			end
			i = i - m
		end
	end
	-- death:
	if (love.keyboard.wasPressed('r')
	or stuck
	or (level.check(this.x, this.y, this.width, this.height, block.deadly))
	or (this.y > level.height * level.gridh - this.height)
	) then -- reset to start position:
		deaths = deaths + 1
		harriet.jumps = 3
		score = score - 50
		level.add(this.x, this.y, harrieteff)
		this.x = this.xstart
		this.y = this.ystart
	end
	-- get coins:
	m = level.meet(this.x, this.y, this.width, this.height, coin)
	if (m) then for i, k in ipairs(m) do
		score = score + 1
		harriet.jumps = harriet.jumps + 1
		level.remove(k)
	end end
	-- got to exit:
	if (level.check(this.x, this.y, this.width, this.height, block.win)) then
		level.next()
	end
	-- limit position:
	k = level.width * level.gridw
	m = level.height * level.gridh
	if (this.y < 0) then this.y = 0 end
	if (this.x < 0) then this.x = 0 end
	if (this.x > k - this.width) then this.x = k - this.width end
	-- snap camera:
	i = love.graphics.getWidth()
	j = love.graphics.getHeight()
	if (k < i) then
		level.x = (k - i) / 2
	else
		level.x = math.min(0, math.max(k - i, this.x + (this.width - i) / 2))
	end
	if (m < j) then
		level.y = (m - j) / 2
	else
		level.x = math.min(0, math.max(m - j + 20, this.y + (this.height - j) / 2))
	end
end
function harriet.draw(this, ox, oy)
	love.graphics.draw(harriet.graphic, this.x + ox, this.y + oy)
end
-- harriet death effect:
harrieteff = {
	graphic = love.graphics.newImage('harriet-eff.png')
}
function harrieteff.create(this, px, py)
	this.x = px - 6
	this.y = py - 6
	this.frame = 0
	this.speed = 48
	this.graphic = harrieteff.graphic
end
function harrieteff.update(this, dt)
	this.frame = this.frame + dt * this.speed
	if (this.frame >= 16) then
		level.remove(this)
	end
end
function harrieteff.draw(this, ox, oy)
	-- utilize animated block drawing function for object:
	block.anim16.draw(this.x / level.gridw, this.y / level.gridh, this, ox, oy)
end
