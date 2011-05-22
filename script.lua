-- Load the font
verdana12 = pge.font.load("verdana.ttf", 10, PGE_RAM)
verdana12:activate()

-- Check the font loaded correctly
if not verdana12 then
	error("Failed to load font.")
end

-- Create a color
white = pge.gfx.createcolor(255, 255, 255)
mColor = pge.gfx.createcolor(255, 255, 255)
mapColor = pge.gfx.createcolor(232, 70, 110)

-- Set an initial state for the net dialog
state = -1
cnt = 0

	coords = {}
	-- Update controls
	pge.controls.update()
	-- Start drawing
	pge.gfx.startdrawing()
	-- Clear screen (to black)
	pge.gfx.clearscreen()
	-- load map from file
	--open file
	mfile = pge.file.open("map.txt", PGE_FILE_RDWR)
	if (not mfile) then
	error("Can't open file map.txt")
	end
	size = pge.file.size(mfile)
	--read from file in str
	str = mfile:read(size)
	for w in str:gmatch("%w+") do coords[#coords+1] = w end 
	pge.font.print(verdana12, 10, 10, white, 'Size coords = ' ..#coords)
	-- End drawing
	pge.gfx.enddrawing()
	-- Swap buffers
	pge.gfx.swapbuffers()

-- initial point of cursor
x=200
y=150

-- function that realize funtion moving cursor
function move_circle()
	if pge.controls.held(PGE_CTRL_LEFT) then
		x=x-1
	end	
	if pge.controls.held(PGE_CTRL_UP) then
		y=y-1
	end	
	if pge.controls.held(PGE_CTRL_DOWN) then
		y=y+1
	end	
	if pge.controls.held(PGE_CTRL_RIGHT) then
		x=x+1
	end	
end	

-- function that print additional information, such as current coords
function print_info()
	pge.font.print(verdana12, 10, 10, white, "x coord:")
	pge.font.print(verdana12, 55, 10, white, x)
	pge.font.print(verdana12, 10, 18, white, "y coord:")
	pge.font.print(verdana12, 55, 18, white, y)
end

logfile=pge.file.open("log.txt", PGE_FILE_RDWR)

function draw_part(a, b, c)
	pge.gfx.startdrawing()
	k=a
	tmp=a+c
	ky=b+40
	kx=130
	cnt=0
	while k<tmp do
		if cnt==300 then
			ky=ky+1
			kx=130
			cnt=0
		end	
		if string.format('%d', coords[k])==string.format('%d', 1) then
			pge.gfx.drawline(kx,ky,kx+1,ky,mColor)
		end
		cnt=cnt+1
		kx=kx+1
		k=k+1
	end
	pge.gfx.enddrawing()	
end

-- draw global map
function draw_global_map()
	
		draw_part(1, 0, 19800)
		draw_part(19801, 66, 20100)
		draw_part(39901 ,133, 20100)
	
	pge.gfx.swapbuffers()
end


	
draw_global_map()


-- main cycle
while pge.running() do

	-- Update controls
	pge.controls.update()
	pge.gfx.startdrawing()
	pge.gfx.clearscreen()

	-- draw circle 
	pge.gfx.drawcircle(x, y, 3, 10, mapColor)
	-- call func
	print_info()
	-- call func to change cursor coords
	move_circle()
	
	-- if R_TRIGGER pressed, repaint main map
	--if pge.controls.pressed(PGE_CTRL_RTRIGGER) then
	--draw_global_map()
	--end
	
	-- If START pressed, end
	if pge.controls.pressed(PGE_CTRL_START) then
		break
	end
	
	pge.gfx.enddrawing()
	-- Swap buffers
	pge.gfx.swapbuffers()
end

