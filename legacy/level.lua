-- Level.lua
-- Engine for grid-based
-- Version: 1.0.2 15/03/2012
-- Author: YellowAfterlife
-- Licence: MIT License
--[[ Copyright (C) 2012 YellowAfterlife

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. ]]--
-- avoid double inclusion:
if (level) then return end
---- REFERENCES ----
require 'trace'
---- CONSTANTS ----
justabit = 0.001 -- used for collision calculations
---- CONSTRUCTOR ----
level = {
	gridw = 32,
	gridh = 32,
	x = 0,
	y = 0,
	blocks = { }
}
---- METHODS ----
-- level.rectc(x1, y1, width1, height1, x2, y2, width2, height2)
-- Returns if given rectangles overlap
function level.rectc(x1, y1, w1, h1, x2, y2, w2, h2)
	return not (y1+h1 <= y2 or y1 >= y2+h2 or x1+w1 <= x2 or x1 >= x2+w2)
end
-- level.meet(x, y, width, height, meta)
-- Returns instances of given kind 'meta' that overlap given rectangle
-- Instance type must have parameters x,y,width,height defining it's bounds
function level.meet(x, y, w, h, meta)
	local idx, obj, rez
	for idx, obj in ipairs(level.objects) do if (obj.meta == meta) then
		if (level.rectc(obj.x, obj.y, obj.width, obj.height, x, y, w, h)) then
			if (rez == nil) then rez = { } end
			table.insert(rez, obj)
		end
	end end
	return rez
end
-- level.check(x, y, width, height, checker)
-- Checks if at least one block overlapping given rect meets given requirement.
-- function checker must be defined as checker(obj), return boolean, and
-- work with object data provided.
function level.check(x, y, w, h, func)
	local x1, y1, x2, y2, i, j, d
	-- find region coordinates to check in:
	x1 = math.floor(x / level.gridw)
	y1 = math.floor(y / level.gridh)
	x2 = math.floor((x + w - justabit) / level.gridw)
	y2 = math.floor((y + h - justabit) / level.gridh)
	for j = y1, y2 do for i = x1, x2 do
		d = level.grid[j] -- find row
		if (d ~= nil) then
			d = d[i] -- find cell
			if (d ~= nil) then
				if (func(d)) then return true end -- test cell
			end
		end
	end end
	return false
end
-- level.add(x, y, objectType)
-- Creates a new object and adds it to the level
function level.add(x, y, object)
	local obj, event
	obj = { meta = object }
	event = obj.meta.create
	if (event) then event(obj, x, y) end
	table.insert(level.objects, obj)
end
-- level.remove(object)
-- Removes an object from level
function level.remove(object)
	local i, v, event
	for i, v in ipairs(level.objects) do if (v == object) then
		event = v.meta.destroy
		if (event) then event(v) end
		table.remove(level.objects, i)
		return true
	end end
	return false
end
-- level.plot(x, y, block)
-- Changes block at given coordinates
function level.plot(x, y, what)
	local i, v, obj
	obj = { }
	for i, v in pairs(what) do obj[i] = v end
	-- call destroy event for old block:
	v = level.grid[y][x]
	if (v) then
		i = v.destroy
		if (i) then i(x, y, v) end
	end
	-- replace block:
	level.grid[y][x] = obj
	-- call creation event for new block:
	i = obj.create
	if (i) then i(x, y, obj) end
end
-- level.load(data, width, height[, name])
-- Loads level from given string.
-- width, height are dimensions of level in blocks.
function level.load(data, width, height, name)
	local x, y, pos, char
	local blockIndex, block, blockType
	local idx, val, obj
	level.width = width
	level.height = height
	love.window.setMode(level.width * 50, level.height * 50)
	level.clear()
	pos = 0
	for y = 0, height-1 do for x = 0, width-1 do
		pos = pos + 1; char = string.sub(data, pos, pos)
		for blockIndex, block in pairs(level.rules) do if (block[1] == char) then
			blockType = block[2]
			if (blockType == nil) then -- blank\air
				break
			elseif (blockType == 0) then -- block
				level.plot(x, y, block[3])
			elseif (blockType == 1) then -- object
				level.add(x * level.gridw, y * level.gridh, block[3])
			else -- unsupported entity type
				trace.print('Unsupported type: ' .. tostring(rt), trace.styles.red)
			end
			break
		end end
	end end
	if (name) then level.name = tostring(name) else level.name = '' end
	level.updated = false
end
-- level.clear()
-- Removes everything from level, updating object list and grid to current size.
function level.clear()
	local x, y, l, c
	-- clear grid:
	level.grid = { }
	for y = 0, level.height-1 do
		l = { }; level.grid[y] = l
		for x = 0, level.width-1 do
			l[x] = { }
		end
	end
	-- clear object list:
	level.objects = { }
end
-- level.update(delta)
-- Updates the level.
-- delta is elapsed time, as passed to love.update
function level.update(dt)
	local x, y, block, event, idx, obj
	level.updated = true
	for y = 0, level.height-1 do for x = 0, level.width-1 do
		block = level.grid[y][x]
		event = block.update
		if (event) then
			event(x, y, block, dt)
		end
	end end
	for idx, obj in ipairs(level.objects) do
		event = obj.meta.update
		if (event) then event(obj, dt) end
	end
end
-- level.draw()
-- Draws the level.
-- Normally to be called in love.render,
-- after background drawing and before UI
function level.draw()
	local x, y, block, event, idx, obj, ox, oy
	if (not level.updated) then level.update(0) end
	ox = -level.x
	oy = -level.y
	love.graphics.setColor(255, 255, 255, 255)
	-- execute draw events for blocks:
	for y = 0, level.height-1 do for x = 0, level.width-1 do
		block = level.grid[y][x]
		event = block.draw
		if (event) then event(x, y, block, ox, oy) end
	end end
	-- execute draw events for objects:
	for idx, obj in ipairs(level.objects) do
		event = obj.meta.draw
		if (event) then event(obj, ox, oy) end
	end
end
