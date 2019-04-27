coin = {
	graphic = love.graphics.newImage('blinky.png'),
}
function coin.create(this, px, py)
	this.x = px + 6
	this.y = py + 6
	this.width = 20
	this.height = 20
	this.wave = 0
end
function coin.update(this, dt)
	this.wave = (this.wave + dt) % (math.pi * 2)
end
function coin.draw(this, ox, oy)
	love.graphics.draw(coin.graphic, this.x + ox, this.y + oy + math.sin(this.wave) * 4)
end