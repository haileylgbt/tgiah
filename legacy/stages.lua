-- stages.lua
-- Contains a function to look-up next level in list.
-- Also contains all levels.
function level.next()
	local d
	level.current = level.current + 1
	d = level.levels[level.current]
	if (d == nil) then
		level.width = 4
		level.height = 4
		level.name = 'Well done.'
		level.clear()
		trace.print('Congratulations! You\'ve completed the game!', trace.styles.green)
	else
		level.load(d[4], d[1], d[2], d[3])
	end
end

-- level definitions:
level.levels = {
	{ 11, 6, 'Hello, Harriet!',
	'           '..
	'           '..
	'           '..
	' p   c   w '..
	'ggg     xxx'..
	'dddgggggxxx'},
	{ 11, 11, "Don't fall",
	'           '..
	'           '..
	'  w        '..
	'xxxxx      '..
	' x x  g    '..
	'   x   c   '..
	'        cgg'..
	'  p c    d '..
	' ggggg  dd '..
	'  ddd      '..
	'    d      '},
	{ 9, 13, 'Jittery chunks',
	'         '..
	'w        '..
	'gg       '..
	'dd  c    '..
	'd   g    '..
	'        c'..
	'        g'..
	'     c   '..
	' c   g c '..
	' g c d g '..
	' dpg d d '..
	'gdgdgdgdg'..
	'ddddddddd'},
	{ 15, 7, 'Doors',
	'       xxx     '..
	'       xxx     '..
	'       xxx     '..
	'       xxx    w'..
	' p     T t   gg'..
	'gggg   T t  gdd'..
	'ddddggxxxxxgddd'},
	{ 11, 5, "Lava is hot, but you're hotter~",
	'x          '..
	'xp      c w'..
	'xxx c d xxx'..
	'xxxxllddxxx'..
	'xxxxxddxxxx'},
	{ 11, 9, 'Madhouse',
	'xxxxxxxxxxx'..
	'xp c x  c x'..
	'xxxxtxTxxtx'..
	'x cT xc x x'..
	'xtxxxxxtxTx'..
	'x T t T x x'..
	'xxxxxxxxxtx'..
	'xw cT t T x'..
	'xxxxxxxxxxx'},
	{ 17, 8, 'Lava pool',
	'                 '..
	'            c    '..
	'    c            '..
	'    x   c        '..
	'  c x   x   T    '..
	'p x x   x   t   w'..
	'glllllllllllllllg'..
	'dllllllllllllllld'},
	{ 7, 13, 'Challenge!',
	'       '..
	'     c '..
	'  gggg '..
	' gdld  '..
	'c  l  g'..
	'g  lcgd'..
	'  cl dd'..
	'c gl  d'..
	'g  l c '..
	'  cl x '..
	'p gl  w'..
	'g  l  g'..
	'dllllld' },
	{ 11, 6, 'Time it right',
	'           '..
	'         w '..
	'    TTT  T '..
	' p       t '..
	'ggg ttt xxx'..
	'dddgggggxxx'},
	{ 11, 7, 'Underground Ventures',
	'           '..
	'           '..
	'           '..
	' p         '..
	'gggtttttggg'..
	'ddc c c  wd'..
	'dddgggggddd'},
	nil
}
