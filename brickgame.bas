INCLUDE HELPER

CONSTANT screen_width = 800
CONSTANT screen_height = 600
CONSTANT left = 37
CONSTANT right = 39
CONSTANT up = 38
CONSTANT down = 40
CONSTANT start = 83

NEWCANVAS "view", 800, 700
CALL SETCANVAS("view")
CALL BLOCKMOVE("view", WINDOWWIDTH()/2 - screen_width/2) 

GLOBAL CREATE game OF Object

ID_GAMELOOP = null

CALL INITGAME()
REPEAT GAMELOOP EVERY 16 WITH ID_GAMELOOP

FUNCTION GAMELOOP()
	CALL GAMECONTROL()
	CALL BALL()
	CALL PLAYERCONTROL()
	CALL DRAW()
ENDFUNCTION

FUNCTION GAMECONTROL()
	IF game\started = 0 
		IF KEYSTATE(start) = 1
			game\started = 1
		ENDIF
	ENDIF

	IF game\gameover = 1
		game\wait = game\wait + 1

		IF game\wait >= 100
			CALL RELOADPAGE()
		ENDIF
	ENDIF
ENDFUNCTION

FUNCTION BALL()
	IF game\started = 0 : RETURN 0 : ENDIF

	REM BRICK HIT
	FOR i = 0 TO ARRAYLEN(game\brick)
		IF BOXCOLLISION(game\ball, game\brick[i]) AND game\brick[i]\dead = 0
			side = AUTOCOLLIDEADJUST(game\ball, game\brick[i])
			SELECT side
				CASE 0 : game\ball\hd = left : BREAK
				CASE 1 : game\ball\hd = right : BREAK
				CASE 2 : game\ball\vd = up : BREAK
				CASE 3 : game\ball\vd = down : BREAK
			ENDSELECT
			game\brick[i]\dead = 1
			BREAK
		ENDIF
	NEXT

	IF BOXCOLLISION(game\ball, game\player)
		CALL AUTOCOLLIDEADJUST(game\ball, game\player)
		game\ball\vd = up
	ENDIF

	FOR i = 0 TO ARRAYLEN(game\wall)
		IF BOXCOLLISION(game\ball, game\wall[i])
			CALL AUTOCOLLIDEADJUST(game\ball, game\wall[i])
			SELECT i
				CASE 0 : game\ball\hd = right : BREAK
				CASE 1 : game\ball\hd = left  : BREAK
				CASE 2 : game\ball\vd = down  : BREAK
			ENDSELECT
			BREAK
		ENDIF 
	NEXT

	IF game\ball\hd = left
		game\ball\x = game\ball\x - game\ball\speed
	ELSEIF game\ball\hd = right
		game\ball\x = game\ball\x + game\ball\speed
	ENDIF

	IF game\ball\vd = up
		game\ball\y = game\ball\y - game\ball\speed
	ELSEIF game\ball\vd = down
		game\ball\y = game\ball\y + game\ball\speed
	ENDIF

	IF game\ball\y > screen_height : game\gameover = 1 : ENDIF
ENDFUNCTION

FUNCTION PLAYERCONTROL()
	IF game\started = 0 : RETURN 0 : ENDIF

	IF KEYSTATE(left) = 1
		game\player\x = game\player\x - game\player\speed
	ENDIF

	IF KEYSTATE(right) = 1
		game\player\x = game\player\x + game\player\speed
	ENDIF

	FOR i = 0 TO ARRAYLEN(game\wall) - 1
		IF BOXCOLLISION(game\player, game\wall[i])
			CALL AUTOCOLLIDEADJUST(game\player, game\wall[i])
		ENDIF
	NEXT
ENDFUNCTION

FUNCTION INITGAME()
	CALL INITKEYBOARD()	

	game\started = 0
	game\gameover = 0
	game\wait = 0

	CREATE game\player OF Object
	game\player\x = screen_width/2
	game\player\y = screen_height - 64
	game\player\width = 128
	game\player\height = 32
	game\player\speed = 6

	CREATE game\ball OF Object
	game\ball\x = screen_width/2
	game\ball\y = screen_height/2
	game\ball\width = 32
	game\ball\height = 32
	game\ball\speed = 4
	game\ball\vd = down

	DIM game\wall
	CREATE game\wall[0] OF Object
	game\wall[0]\x = 0
	game\wall[0]\y = 0
	game\wall[0]\width = 8
	game\wall[0]\height = screen_height
	
	CREATE game\wall[1] OF Object
	game\wall[1]\x = screen_width - 8
	game\wall[1]\y = 0
	game\wall[1]\width = 8
	game\wall[1]\height = screen_height

	CREATE game\wall[2] OF Object
	game\wall[2]\x = 0
	game\wall[2]\y = 0
	game\wall[2]\width = screen_width
	game\wall[2]\height = 8

	direction = RND(1,0)
	IF direction = 0 : game\ball\hd = left : ENDIF
	IF direction = 1 : game\ball\hd = right : ENDIF	
	
	DIM game\brick

	level = LOADLEVEL()
	x = 8
	y = 64
	b = 0

	FOR j = 0 TO ARRAYLEN(level)
	FOR i = 1 TO LEN(level[j])
		IF MID(level[j], i, 1) = "b"
			CREATE game\brick[b] OF Object
			game\brick[b]\x = x
			game\brick[b]\y = y
			game\brick[b]\width = 64
			game\brick[b]\height = 32
			game\brick[b]\dead = 0
			b = b + 1
		ENDIF
			x = x + 66
	NEXT
		x = 8
		y = y + 34
	NEXT

	REM prepare colors
	CREATE game\colors OF Object
	game\colors\red = RGB(255, 0, 0)
	game\colors\green = RGB(0, 255, 0)
	game\colors\blue = RGB(0, 0, 255)
	game\colors\black = RGB(0, 0, 0)
	game\colors\white = RGB(255, 255, 255)
	game\colors\gray = RGB(194, 194, 194)
ENDFUNCTION

FUNCTION DRAW()
	CALL COLOR(game\colors\black)
	CALL CLEARRECT(0, 0, screen_width, screen_height)
	CALL FILLRECT(0, 0, screen_width, screen_height) : REM clear screen

	CALL COLOR(game\colors\red)
	CALL FILLRECT(game\player\x, game\player\y, game\player\width, game\player\height)

	CALL COLOR(game\colors\white)
	CALL FILLCIRCLE(game\ball\x+16, game\ball\y+16, game\ball\width / 2)
	
	CALL COLOR(game\colors\blue)
	FOR i = 0 TO ARRAYLEN(game\brick)
		IF game\brick[i]\dead = 0
			CALL FILLRECT(game\brick[i]\x, game\brick[i]\y, game\brick[i]\width, game\brick[i]\height)
		ENDIF
	NEXT

	CALL COLOR(game\colors\gray)
	FOR i = 0 TO ARRAYLEN(game\wall)
		CALL FILLRECT(game\wall[i]\x, game\wall[i]\y, game\wall[i]\width, game\wall[i]\height)
	NEXT

	IF game\started = 0
		CALL DRAWTITLESCREEN()
	ELSEIF game\gameover = 1
		CALL DRAWGAMEOVERSCREEN()
		RETURN 0
	ENDIF
ENDFUNCTION

FUNCTION PRINTCENTER(text, y)
	width = TEXTWIDTH(text) / 2
	CALL TEXT(screen_width/2 - width, y, text)
ENDFUNCTION

FUNCTION DRAWTITLESCREEN()
	CALL COLOR(game\colors\green)
	CALL SETFONT(86, "BRITANNIC BOLD")
	CALL PRINTCENTER("BRICKEDOUT", 256)
	CALL SETFONT(32, "BRITANNIC BOLD")
	CALL PRINTCENTER("Created with BTJC", screen_height/2)
	CALL SETFONT(16, "BRITANNIC BOLD")
	CALL PRINTCENTER("Press 's' to Start", screen_height/2 + 34)
ENDFUNCTION

FUNCTION DRAWGAMEOVERSCREEN()
	CALL COLOR(game\colors\green)
	CALL SETFONT(86, "BRITANNIC BOLD")
	CALL PRINTCENTER("GAME OVER", 256)
	CALL SETFONT(16, "BRITANNIC BOLD")
	CALL PRINTCENTER("Reloading...", screen_height/2)
ENDFUNCTION

FUNCTION LOADLEVEL()
	DIM level
	level[0] = "bbbbbbbbbbbb"
	level[1] = "bbbbbbbbbbbb"
	level[2] = "bbbbbbbbbbbb"
	level[3] = "bbbb0000bbbb"
	RETURN level
ENDFUNCTION
