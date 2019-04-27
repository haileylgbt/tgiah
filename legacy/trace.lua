if (trace) then return end
trace = {
	textl = { },
	stylel = { },
	styles = {
		white = { r = 255, g = 255, b = 255 },
		red = { r = 255, g = 127, b = 127 },
		green = { r = 191, g = 255, b = 127 },
		blue = { r = 127, g = 159, b = 255 },
		yellow = { r = 255, g = 240, b = 127 },
		-- add your own style definitions here
		default = { r = 224, g = 224, b = 224 }
	},
	count = 0,
	limit = 32
}
function trace.print(text, style)
	if (style == nil) then -- no style given
		style = trace.styles.default
	end
	if (trace.count > trace.limit) then -- scroll elements
		table.remove(trace.textl, 1)
		table.remove(trace.stylel, 1)
	else -- add element
		trace.count = trace.count + 1
	end -- write data:
	trace.textl[trace.count] = text
	trace.stylel[trace.count] = style
end
function trace.draw(x, y)
	local i, s, z, prefix
	prefix = '' 
	-- default position parameters:
	if (x == nil) then x = 16 end
	if (y == nil) then y = 16 end
	-- draw lines:
	for i = 1, trace.count do
		s = trace.stylel[i]
		z = prefix .. trace.textl[i] -- string to draw
		-- choose white/black outline:
		if ((s.r < 160) and (s.g < 160) and (s.b < 160)) then
			love.graphics.setColor(255, 255, 255)
		else
			love.graphics.setColor(0, 0, 0)
		end
		-- draw outline:
		love.graphics.print(z, x + 1, y)
		love.graphics.print(z, x - 1, y)
		love.graphics.print(z, x, y + 1)
		love.graphics.print(z, x, y - 1)
		-- draw color:
		love.graphics.setColor(s.r, s.g, s.b)
		love.graphics.print(z, x, y)
		-- concatenate prefix:
		prefix = prefix .. '\n'
	end
end