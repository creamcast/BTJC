INCLUDE HELPER

CONSTANT screen_width = 800
CONSTANT screen_height = 700
CONSTANT left = 37
CONSTANT right = 39
CONSTANT up = 38
CONSTANT down = 40
CONSTANT start = 83
CONSTANT viewwidth = 192
CONSTANT raystep = 0.005
CONSTANT slwidth = 4

CONSTANT wall = 1

NEWCANVAS "view", 800, 700
CALL SETCANVAS("view")

CALL BLOCKMOVE("view", WINDOWWIDTH()/2 - screen_width/2) 

NEWSCREEN "output"
SCREEN "output"

GLOBAL CREATE game OF Object
ID_GAMELOOP = null

CALL INITGAME()
REPEAT GAMELOOP EVERY 16 WITH ID_GAMELOOP

FUNCTION INITGAME()
	CALL INITKEYBOARD()

	CREATE game\colors OF Object
	game\colors\red = RGB(255, 0, 0)
	game\colors\blue = RGB(0, 0, 255)
	game\colors\green = RGB(0,255,0)
	game\colors\black = RGB(0,0,0)
	game\colors\gray = RGB(194, 194, 194)

	level = LOADLEVEL1()
	DIM game\tile
	x = 0
	y = 0
	n = 0
	si = 1
	tilesize = 32
	FOR i = 0 TO ARRAYLEN(level)
		DO
			t = MID(level[i], si, 1) 
			IF t = ""
				si= 1
				BREAK
			ELSEIF t = "1"
				CREATE game\tile[n] OF Object
				game\tile[n]\type = wall
				game\tile[n]\x = x
				game\tile[n]\y = y
				game\tile[n]\width = tilesize
				game\tile[n]\height = tilesize
				n = n + 1
			ENDIF
			x = x + tilesize
			si = si + 1
		LOOP
		x = 0
		y = y + tilesize
	NEXT

	CREATE game\player OF Object
	game\player\x = 100
	game\player\y = 100
	game\player\width = 4
	game\player\height = 4
	game\player\dx = game\player\x + game\player\width / 2
	game\player\dy = game\player\y + game\player\height / 2
	game\player\speed = 2
	game\player\tspeed = 0.04
	game\player\angle = 0
	game\player\rot = 0
	game\player\length = 16


	DIM game\ray
	FOR i = 0 TO viewwidth
		CREATE game\ray[i] OF Object
		game\ray[i]\sx = 0
		game\ray[i]\sy = 0
		game\ray[i]\x = 0
		game\ray[i]\y = 0
		game\ray[i]\width = 1
		game\ray[i]\height = 1
		game\ray[i]\distance = 0
		game\ray[i]\cdistance = 0
		game\ray[i]\color = RGB(0,0,0)
		game\ray[i]\odd = 0
	NEXT

	REM textures
	CREATE game\textures OF Object
	game\textures\test = LOADIMAGE("aj.png")
ENDFUNCTION

REM ----------------------------------------------------------------------
REM 						DRAW
REM ----------------------------------------------------------------------

FUNCTION DRAW()
	CALL COLOR(game\colors\black)
	CALL FILLRECT(0,0,800,screen_height)

	CALL COLOR(game\colors\blue)
	FOR i = 0 TO ARRAYLEN(game\tile)
		CALL FILLRECT(game\tile[i]\x, game\tile[i]\y, game\tile[i]\width, game\tile[i]\height)
	NEXT

	REM draw player
	CALL STROKE(game\colors\green)
	CALL LINE(game\player\x + game\player\width / 2, game\player\y + game\player\height / 2, game\player\dx, game\player\dy)
	
	CALL COLOR(game\colors\green)
	CALL FILLRECT(game\player\x, game\player\y, game\player\width, game\player\height)

	REM CALL DRAWRAYS()
	CALL PROJECTSLICES()
ENDFUNCTION

FUNCTION DRAWRAYS()
	CALL STROKE(game\colors\red)
	FOR i = 0 TO ARRAYLEN(game\ray)
		CALL LINE(game\ray[i]\sx, game\ray[i]\sy, game\ray[i]\x, game\ray[i]\y)
	NEXT
ENDFUNCTION

FUNCTION PROJECTSLICES()
	x = 10
	yoffset = 350
	pp = 300
	ppcenter = 300/2
	distancetopp = 128
	wallheight = 192 : REM make same or near viewwidth

	slicewidth = slwidth

	FOR i = ARRAYLEN(game\ray) TO 0 STEP -1
		sliceheight = ROUND( wallheight / game\ray[i]\cdistance * distancetopp )
		y = ( ppcenter - ( sliceheight/2 ) ) + yoffset 

		IF y <= yoffset : y = yoffset : ENDIF
		IF sliceheight >= pp : sliceheight = pp : ENDIF
		
		CALL COLOR(game\ray[i]\color)
		CALL FILLRECT(x, y, slicewidth, sliceheight)
		x = x + slicewidth
	NEXT

ENDFUNCTION

FUNCTION GAMELOOP()
	CALL PLAYERCONTROL()
	CALL PLAYERCOLLISION()
	CALL CALCLINE()
	CALL CALCRAY()
	
	CALL DRAW()
ENDFUNCTION

FUNCTION PLAYERCONTROL()
	IF KEYSTATE(left) = 1
		REM game\player\x = game\player\x - game\player\speed
		game\player\angle = game\player\angle + game\player\tspeed
	ENDIF

	IF KEYSTATE(right) = 1
		REM game\player\x = game\player\x + game\player\speed
		game\player\angle = game\player\angle - game\player\tspeed
	ENDIF

	IF KEYSTATE(up) = 1
		game\player\y = game\player\y + COS(game\player\angle) * game\player\speed
		game\player\x = game\player\x + SIN(game\player\angle) * game\player\speed
	ENDIF

	IF KEYSTATE(down) = 1
		game\player\y = game\player\y - COS(game\player\angle) * game\player\speed
		game\player\x = game\player\x - SIN(game\player\angle) * game\player\speed
	ENDIF
ENDFUNCTION

FUNCTION CALCLINE()
	a = game\player\angle
	r = game\player\length
	cx = game\player\x + game\player\width / 2
	cy = game\player\y + game\player\height / 2
	game\player\dx = cx + r * SIN(a)
	game\player\dy = cy + r * COS(a)
ENDFUNCTION

FUNCTION CALCRAY()
	step = raystep
	a = game\player\angle - ( viewwidth / 2 ) * step

	FOR l = 0 TO ARRAYLEN(game\ray)
		a = a + step
		r = 0

		game\ray[l]\sx = game\player\x + game\player\width / 2
		game\ray[l]\sy = game\player\y + game\player\height / 2

		f = 0
		DO
			IF f = 1 : BREAK : ENDIF
			game\ray[l]\x = game\ray[l]\sx + r * SIN(a)
			game\ray[l]\y = game\ray[l]\sy + r * COS(a)
			r = r + 1

			FOR i = 0 TO ARRAYLEN(game\tile)
				IF BOXCOLLISION(game\ray[l], game\tile[i])
					f = 1
					BREAK
				ENDIF
			NEXT
		LOOP

		game\ray[l]\distance = r
		game\ray[l]\cdistance = r * COS(game\player\angle - a)

		REM COLORS		
		colornum = ROUND( game\ray[l]\distance )
		colornum = 255 - colornum
		game\ray[l]\color = RGB(colornum, 0, 0)

	NEXT

ENDFUNCTION

FUNCTION PLAYERCOLLISION()
	FOR i = 0 TO ARRAYLEN(game\tile)
		IF BOXCOLLISION(game\player, game\tile[i])
			CALL AUTOCOLLIDEADJUST(game\player, game\tile[i])
		ENDIF
	NEXT
ENDFUNCTION

FUNCTION LOADLEVEL1()
	DIM level
	level[0] = "111111111111111111"
	level[1] = "100000000000000001"
	level[2] = "100001010100000001"
	level[3] = "10000000000000000111111111"
	level[4] = "10000000000000000000000001"
	level[5] = "10000111110000000111111101"
	level[6] = "10000100010000000100000101"
	level[7] = "10100000000011110111111101"
	level[8] = "10000000000000000000000001"
	level[9] = "11111111111111111111111111"
	RETURN level
ENDFUNCTION