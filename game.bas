INCLUDE HELPER
NEWCANVAS "canvassample", 800, 600
MAKEHTML(onclick="INIT()") "BUTTON" "PLAY"
NEWSCREEN "main"
SCREEN "main"
GLOBAL ID_DRAW = null
SUB INIT()	
	CALL SETCANVAS("canvassample")
	CLS
	CALL STOPWCALL(ID_DRAW)
	CALL INITKEYBOARD()
	CREATE game OF Object
	CREATE game\player OF Object
	CREATE game\camcenter OF Object
	CREATE game\screenedge OF Object
	
	LET game\camcenter\x = 800/2
	LET game\camcenter\y = 0
	LET game\camcenter\width = 800/2
	LET game\camcenter\height = 600
	
	LET game\screenedge\x = 0 - 64
	LET game\screenedge\y = 0
	LET game\screenedge\width = 64
	LET game\screenedge\height = 600
	
	REM player
	LET game\player\x = 0
	LET game\player\y = 0
	LET game\player\height = 64
	LET game\player\width = 32
	LET game\player\spritesheet = LOADIMAGE("player1.png")
	LET game\player\spritesize = 64
	LET game\player\row = game\player\spritesize * 4
	LET game\player\col = game\player\spritesize * 0
	LET game\player\frame = 1
	LET game\player\cycletime = 0
	LET game\player\jumping = 0
	LET game\player\falling = 1
	LET game\player\jumptime = 0
	LET game\player\direction = 0
	LET game\player\onground = 0
	LET game\player\speed = 0
	LET game\player\jumpspeed = 0
	LET game\player\fallspeed = 0
	LET game\player\firing = 0
	LET game\player\dead = 0
	
	LET game\coinimg = LOADIMAGE("coin.png")
	
	REM load level
	CALL LOADLEVEL1(game)
	
	REM enemies
	LET game\enemyimg = LOADIMAGE("poisonm.png")
	LET game\ballimg = LOADIMAGE("ball.png")
	LET game\spawntime = 0
	
	DIM game\enemy
	CREATE game\enemy[0] OF Object
	LET game\enemy[0]\x = 0
	LET game\enemy[0]\y = -50
	LET game\enemy[0]\width = 32
	LET game\enemy[0]\height = 32
	LET game\enemy[0]\spawned = 0
	LET game\enemy[0]\dead = 0
	LET game\enemy[0]\direction = 0
	
	CREATE game\enemy[1] OF Object
	LET game\enemy[1]\x = 0
	LET game\enemy[1]\x = -50
	LET game\enemy[1]\width = 64
	LET game\enemy[1]\height = 64
	LET game\enemy[1]\spawned = 0
	
	REM scene
	LET game\scenex = 0
	LET game\sceney = 0
	
	REM sound
	LET game\firesound = LOADSOUND("line.wav")
	LET game\jumpsound = LOADSOUND("jump.wav")
	LET game\hitsound = LOADSOUND("hit.wav")
	LET game\coinsound = LOADSOUND("coin.wav")
	
	CREATE time OF Date
	LET timep = time\getTime() + 10
	
	CALL MAINLOOP(game, timep)
ENDSUB

SUB LEFTTOUCH()
	LET n = touchinfo\total
	IF n = 0 : RETURN false : ENDIF
	IF n = undefined : RETURN false : ENDIF
	IF touchinfo\touches[1]\pageX < 100 : RETURN true : ENDIF
	RETURN false
ENDSUB

SUB RIGHTTOUCH()
	LET n = touchinfo\total
	IF n = 0 : RETURN false : ENDIF
	IF n = undefined : RETURN false : ENDIF
	IF touchinfo\touches[1]\pageX > 100 AND touchinfo\touches[1]\pageX < 600 : RETURN true : ENDIF
	RETURN false
ENDSUB

SUB JUMPTOUCH()
	LET n = touchinfo\total
	IF n = 0 : RETURN false : ENDIF
	IF n = undefined : RETURN false : ENDIF
	
	IF touchinfo\touches[2]\pageX > 700 : RETURN true : ENDIF
	IF touchinfo\touches[1]\pageX > 700 : RETURN true : ENDIF
	RETURN false
ENDSUB

SUB MAINLOOP(game, timep)
	
	LET moved = 0
	
	IF (KEYSTATE(37) = 1 AND game\player\dead = 0) OR (LEFTTOUCH() = true AND game\player\dead = 0)
	  LET game\player\x = game\player\x - game\player\speed
	  LET game\player\direction = 1
	  LET moved = 1
	ENDIF
	
	IF (KEYSTATE(39) = 1 AND game\player\dead = 0) OR (RIGHTTOUCH() = true AND game\player\dead = 0)
	  LET game\player\x = game\player\x + game\player\speed
	  LET game\player\direction = 0
	  LET moved = 2
	ENDIF
	
	IF moved <> 0
	  LET game\player\speed = game\player\speed + 0.05
	  IF game\player\speed > 4
		LET game\player\speed = 4
	  ENDIF
	ELSE
	  LET game\player\speed = game\player\speed - 0.1
	  
	  IF game\player\speed <= 0 : LET game\player\speed = 0 : ENDIF
	  IF game\player\direction = 1 : LET game\player\x = game\player\x - game\player\speed : ENDIF
	  IF game\player\direction = 0 : LET game\player\x = game\player\x + game\player\speed : ENDIF
	ENDIF
	
	
	IF KEYSTATE(88) = 1 AND game\player\firing = 0
	  CALL PLAYSOUND(game\firesound)
	  LET game\player\firing = 1
	  LET game\player\frame = 4
	  LET game\player\cycletime = 0
	ENDIF
	
	REM Jumping
	IF (KEYSTATE(38) = 1 AND game\player\jumping = 0 AND game\player\falling = 0 AND game\player\onground = 1 AND game\player\dead = 0) OR (JUMPTOUCH() = true AND game\player\jumping = 0 AND game\player\falling = 0 AND game\player\onground = 1 AND game\player\dead = 0)
	  LET game\player\jumping = 1
	  LET game\player\jumpspeed = 6
	  LET game\player\cycletime = 0
	  
	  LET game\player\frame = 0
	  LET game\player\fallspeed = 0
	  CALL PLAYSOUND(game\jumpsound)
	ENDIF
	
	IF game\player\jumping = 1
	  LET game\player\y = game\player\y - game\player\jumpspeed
	  LET game\player\jumptime = game\player\jumptime + 1
	  LET game\player\jumpspeed = game\player\jumpspeed - 0.1
	  
	  IF game\player\jumpspeed < 0 : LET game\player\jumpspeed = 0 : ENDIF
	  IF game\player\jumptime > 50
		LET game\player\falling = 1
		LET game\player\jumping = 0
		LET game\player\jumptime = 0
	  ENDIF
	ENDIF
	
	REM gravity
	IF game\player\jumping = 0
	  LET game\player\y = game\player\y + game\player\fallspeed
	  LET game\player\fallspeed = game\player\fallspeed + 0.4
	  IF game\player\fallspeed > 6
		LET game\player\fallspeed = 6
	  ENDIF
	ENDIF
	
	IF game\player\firing = 1
	  IF game\player\frame = 0
		LET game\player\firing = 0
	  ENDIF
	ENDIF
	
	REM choose which sprite to display
	
	IF game\player\dead = 1
	  CALL SETSPRITEROW(game, 2)
	  IF game\player\frame = 6
		LET game\player\frame = 6
		LET game\player\cycletime = 0
	  ENDIF
	ELSEIF game\player\firing = 1
	  CALL SETSPRITEROW(game, 1)
	ELSEIF game\player\falling = 1 AND game\player\direction = 0
	  CALL SETSPRITEROW(game, 5)
	  LET game\player\cycletime = 0
	  LET game\player\frame = 6
	ELSEIF game\player\falling = 1 AND game\player\direction = 1
	  CALL SETSPRITEROW(game, 6)
	  LET game\player\cycletime = 0
	  LET game\player\frame = 6
	ELSEIF game\player\jumping = 1 AND game\player\direction = 0
	  CALL SETSPRITEROW(game, 5)
	  IF game\player\frame = 6
		LET game\player\cycletime = 5
	  ENDIF
	ELSEIF game\player\jumping = 1 AND game\player\direction = 1
	  CALL SETSPRITEROW(game, 6)
	  IF game\player\frame = 6
		LET game\player\cycletime = 5
	  ENDIF
	ELSEIF moved = 1
	  CALL SETSPRITEROW(game, 9)
	ELSEIF moved = 2
	  CALL SETSPRITEROW(game, 4)
	ELSEIF game\player\direction = 0
	  CALL SETSPRITEROW(game, 8)
	  LET game\player\cycletime = 0
	  LET game\player\frame = 0
	ELSEIF game\player\direction = 1
	  CALL SETSPRITEROW(game, 8)
	  LET game\player\cycletime = 0
	  LET game\player\frame = 1
	ENDIF
	
	REM enemy spawning
	IF game\scenex < -100 AND game\enemy[0]\spawned = 0
	  LET game\enemy[0]\spawned = 1
	  LET game\enemy[0]\x = ( -1 * game\scenex ) + 800
	  LET game\enemy[0]\y = RND(500, 100)
	ENDIF
	
	IF game\spawntime >= 150 AND game\enemy[1]\spawned = 0
	  IF RND(2, 1) = 2
		CALL PLAYSOUND(game\firesound)
		LET game\enemy[1]\spawned = 1
		LET game\enemy[1]\x = ( -1 * game\scenex ) + 800
		LET game\enemy[1]\y = game\player\y
	  ENDIF
	  LET game\spawntime = 0
	ELSE
	  LET game\spawntime = game\spawntime + 1
	ENDIF
	
	REM ball firing
	IF game\enemy[1]\spawned = 1
	  LET game\enemy[1]\x = game\enemy[1]\x - 6
	  IF BOXCOLLISION(game\enemy[1], game\screenedge) = true
		LET game\enemy[1]\spawned = 0
	  ENDIF
	  
	  IF BOXCOLLISION(game\enemy[1], game\player) = true AND game\player\dead = 0
		LET game\player\dead = 1
		LET game\player\frame = 0
		CALL PLAYSOUND(game\hitsound)
		PRINT "YOU DIED!"
	  ENDIF
	ENDIF
	
	REM enemies moving
	IF game\enemy[0]\spawned = 1
	  REM direction
	  IF game\enemy[0]\direction = 0 : LET game\enemy[0]\x = game\enemy[0]\x - 4 : ENDIF
	  IF game\enemy[0]\direction = 1 : LET game\enemy[0]\x = game\enemy[0]\x + 4 : ENDIF
	  
	  REM gravity
	  LET game\enemy[0]\y = game\enemy[0]\y + 4
	  
	  LET len = ARRAYLEN(game\obstacle)
	  FOR i = 0 TO len
		IF BOXCOLLISION(game\enemy[0], game\obstacle[i]) = true
		  LET e = AUTOCOLLIDEADJUST(game\enemy[0], game\obstacle[i])
		  IF e = 1 : LET game\enemy[0]\direction = 1 : ENDIF
		  IF e = 0 : LET game\enemy[0]\direction = 0 : ENDIF
		ENDIF
	  NEXT
	  
	  IF BOXCOLLISION(game\enemy[0], game\player) = true AND game\player\dead = 0
		LET game\player\dead = 1
		LET game\player\frame = 0
		CALL PLAYSOUND(game\hitsound)
		PRINT "YOU DIED!"
	  ENDIF
	  
	  IF game\player\x - game\enemy[0]\x > 500
		LET game\enemy[0]\spawned = 0
	  ENDIF
	  
	  IF game\enemy[0]\y > 800 : LET game\enemy[0]\spawned = 0 : ENDIF
	ENDIF
	
	REM ---------------HIT DETECTION-------------------
	
	REM Obstacles
	LET len = ARRAYLEN(game\obstacle)
	FOR i = 0 TO len
	  
	  IF INDISTANCE(game, i) = true
		
		IF BOXCOLLISION(game\player, game\obstacle[i]) = true
		  LET where = AUTOCOLLIDEADJUST(game\player, game\obstacle[i])
		  IF where = 2
			LET game\player\falling = 0
			LET game\player\onground = 1
		  ELSEIF where = 3 : REM hit obstacle cieling
			LET game\player\jumptime = 90
			LET game\player\jumpspeed = 0
		  ELSE
			LET game\player\onground = 0
		  ENDIF
		ENDIF
		
	  ENDIF
	NEXT
	
	LET len = ARRAYLEN(game\coin)
	FOR i = 0 TO len
	  IF BOXCOLLISION(game\player, game\coin[i]) = true AND game\coin[i]\color <> ""
		LET game\coin[i]\color = ""
		CALL PLAYSOUND(game\coinsound)
	  ENDIF
	NEXT
	
	IF BOXCOLLISION(game\player, game\camcenter) = true
	  LET game\scenex = game\scenex - game\player\speed
	  LET game\camcenter\x = game\camcenter\x + game\player\speed
	  LET game\screenedge\x = game\screenedge\x + game\player\speed
	ENDIF
	
	IF BOXCOLLISION(game\player, game\screenedge) = true
	  CALL AUTOCOLLIDEADJUST(game\player, game\screenedge)
	ENDIF
	
	CREATE time OF Date
	IF time\getTime() > timep
		CALL CYCLEFRAME(game)
		CALL DRAW(game)
		LET timep = time\getTime() + 10
	ENDIF
	
	WCALL ID_DRAW MAINLOOP(game, timep) 16
ENDSUB


SUB DRAW(game)
	LET red = RGB(255,0,0)
	LET green = RGB(0,255,0)
	LET black = RGB(0, 0, 0)
	LET skyblue = RGB(135, 206, 250)
	
	CALL CLEARRECT( 0,0,800,600)
	CALL COLOR( skyblue)
	CALL FILLRECT( 0,0,800,600)
	
	REM draw player
	CALL COLOR( green)
	REM CALL FILLRECT( game\player\x + game\scenex, game\player\y, game\player\width, game\player\height)
	CALL SLICEDIMAGE( game\player\spritesheet, GETWHICHSPRITE(game), game\player\row, 64, 64, game\player\x - 16 + game\scenex, game\player\y, 64, 64)
	
	REM draw enemies
	IF game\enemy[0]\spawned = 1
	  CALL IMAGE( game\enemyimg, game\enemy[0]\x + game\scenex, game\enemy[0]\y, 32, 32)
	ENDIF
	
	LET len = ARRAYLEN(game\obstacle)
	FOR i = 0 TO len
	  IF INDISTANCE(game, i) = true
		CALL COLOR( game\obstacle[i]\color)
		CALL FILLRECT( game\obstacle[i]\x + game\scenex, game\obstacle[i]\y, game\obstacle[i]\width, game\obstacle[i]\height)
	  ENDIF
	NEXT
	
	CALL COLOR( "#FFFF00")
	LET len = ARRAYLEN(game\coin)
	FOR i = 0 TO len
	  IF game\coin[i]\color <> ""
		CALL IMAGE( game\coinimg, game\coin[i]\x + game\scenex, game\coin[i]\y, 32, 32)
	  ENDIF
	NEXT
	
	IF game\enemy[1]\spawned = 1
	  CALL IMAGE( game\ballimg, game\enemy[1]\x + game\scenex, game\enemy[1]\y, game\enemy[1]\width, game\enemy[1]\height)
	ENDIF
ENDSUB

SUB CYCLEFRAME(game)
	LET cframe = game\player\frame
	IF game\player\cycletime > 5
	  LET cframe = cframe + 1
	  LET game\player\cycletime = 0
	ELSE
	  LET game\player\cycletime = game\player\cycletime + 1
	ENDIF
	
	IF cframe >= 7
	  LET cframe = 0
	ENDIF
	LET game\player\frame = cframe
ENDSUB

SUB SETSPRITEROW(game, row)
	LET game\player\row = game\player\spritesize * row
	ENDSUB
	
	SUB GETWHICHSPRITE(game)
	RETURN game\player\spritesize * game\player\frame
ENDSUB

SUB INDISTANCE(game, i)
	IF ( game\obstacle[i]\x - game\player\x < 800 AND game\player\x - game\obstacle[i]\x < 800 ) OR LEFT(game\obstacle[i]\name, 6) = "ground"
	  RETURN true
	ELSE
	  RETURN false
	ENDIF
ENDSUB

SUB LOADLEVEL1(game)
	DIM game\coin
	CREATE game\coin[0] OF Object
	LET game\coin[0]\x = 5337
	LET game\coin[0]\y = 80
	LET game\coin[0]\width = 32
	LET game\coin[0]\height = 32
	LET game\coin[0]\color = "#000000"
	LET game\coin[0]\name = "coin10"
	CREATE game\coin[1] OF Object
	LET game\coin[1]\x = 6080
	LET game\coin[1]\y = 60
	LET game\coin[1]\width = 32
	LET game\coin[1]\height = 32
	LET game\coin[1]\color = "#000000"
	LET game\coin[1]\name = "coin11"
	CREATE game\coin[2] OF Object
	LET game\coin[2]\x = 9186
	LET game\coin[2]\y = 140
	LET game\coin[2]\width = 32
	LET game\coin[2]\height = 32
	LET game\coin[2]\color = "#000000"
	LET game\coin[2]\name = "coin13"
	CREATE game\coin[3] OF Object
	LET game\coin[3]\x = 7786
	LET game\coin[3]\y = 19
	LET game\coin[3]\width = 32
	LET game\coin[3]\height = 32
	LET game\coin[3]\color = "#000000"
	LET game\coin[3]\name = "coin14"
	CREATE game\coin[4] OF Object
	LET game\coin[4]\x = 6886
	LET game\coin[4]\y = 240
	LET game\coin[4]\width = 32
	LET game\coin[4]\height = 32
	LET game\coin[4]\color = "#000000"
	LET game\coin[4]\name = "coin15"
	CREATE game\coin[5] OF Object
	LET game\coin[5]\x = 400
	LET game\coin[5]\y = 220
	LET game\coin[5]\width = 32
	LET game\coin[5]\height = 32
	LET game\coin[5]\color = "#000000"
	LET game\coin[5]\name = "coin1"
	CREATE game\coin[6] OF Object
	LET game\coin[6]\x = 677
	LET game\coin[6]\y = 80
	LET game\coin[6]\width = 32
	LET game\coin[6]\height = 32
	LET game\coin[6]\color = "#000000"
	LET game\coin[6]\name = "coin2"
	CREATE game\coin[7] OF Object
	LET game\coin[7]\x = 1348
	LET game\coin[7]\y = 220
	LET game\coin[7]\width = 32
	LET game\coin[7]\height = 32
	LET game\coin[7]\color = "#000000"
	LET game\coin[7]\name = "coin4"
	CREATE game\coin[8] OF Object
	LET game\coin[8]\x = 2977
	LET game\coin[8]\y = 280
	LET game\coin[8]\width = 32
	LET game\coin[8]\height = 32
	LET game\coin[8]\color = "#000000"
	LET game\coin[8]\name = "coin5"
	CREATE game\coin[9] OF Object
	LET game\coin[9]\x = 4317
	LET game\coin[9]\y = 240
	LET game\coin[9]\width = 32
	LET game\coin[9]\height = 32
	LET game\coin[9]\color = "#000000"
	LET game\coin[9]\name = "coin6"
	CREATE game\coin[10] OF Object
	LET game\coin[10]\x = 3317
	LET game\coin[10]\y = 280
	LET game\coin[10]\width = 32
	LET game\coin[10]\height = 32
	LET game\coin[10]\color = "#000000"
	LET game\coin[10]\name = "coin7"
	CREATE game\coin[11] OF Object
	LET game\coin[11]\x = 3797
	LET game\coin[11]\y = 200
	LET game\coin[11]\width = 32
	LET game\coin[11]\height = 32
	LET game\coin[11]\color = "#000000"
	LET game\coin[11]\name = "coin8"
	CREATE game\coin[12] OF Object
	LET game\coin[12]\x = 4497
	LET game\coin[12]\y = 207
	LET game\coin[12]\width = 32
	LET game\coin[12]\height = 32
	LET game\coin[12]\color = "#000000"
	LET game\coin[12]\name = "coin9"
	DIM game\obstacle
	CREATE game\obstacle[0] OF Object
	LET game\obstacle[0]\x = 10486
	LET game\obstacle[0]\y = 272
	LET game\obstacle[0]\width = 128
	LET game\obstacle[0]\height = 128
	LET game\obstacle[0]\color = "#8000FF"
	LET game\obstacle[0]\name = "goal"
	CREATE game\obstacle[1] OF Object
	LET game\obstacle[1]\x = 9926
	LET game\obstacle[1]\y = 272
	LET game\obstacle[1]\width = 128
	LET game\obstacle[1]\height = 128
	LET game\obstacle[1]\color = "#008000"
	LET game\obstacle[1]\name = "pipe2"
	CREATE game\obstacle[2] OF Object
	LET game\obstacle[2]\x = 6657
	LET game\obstacle[2]\y = 340
	LET game\obstacle[2]\width = 64
	LET game\obstacle[2]\height = 64
	LET game\obstacle[2]\color = "#804040"
	LET game\obstacle[2]\name = "stair1"
	CREATE game\obstacle[3] OF Object
	LET game\obstacle[3]\x = 6717
	LET game\obstacle[3]\y = 280
	LET game\obstacle[3]\width = 64
	LET game\obstacle[3]\height = 128
	LET game\obstacle[3]\color = "#804040"
	LET game\obstacle[3]\name = "stair2"
	CREATE game\obstacle[4] OF Object
	LET game\obstacle[4]\x = 6777
	LET game\obstacle[4]\y = 220
	LET game\obstacle[4]\width = 64
	LET game\obstacle[4]\height = 192
	LET game\obstacle[4]\color = "#804040"
	LET game\obstacle[4]\name = "stair3"
	CREATE game\obstacle[5] OF Object
	LET game\obstacle[5]\x = 6957
	LET game\obstacle[5]\y = 220
	LET game\obstacle[5]\width = 64
	LET game\obstacle[5]\height = 192
	LET game\obstacle[5]\color = "#804040"
	LET game\obstacle[5]\name = "stair4"
	CREATE game\obstacle[6] OF Object
	LET game\obstacle[6]\x = 7017
	LET game\obstacle[6]\y = 280
	LET game\obstacle[6]\width = 64
	LET game\obstacle[6]\height = 128
	LET game\obstacle[6]\color = "#804040"
	LET game\obstacle[6]\name = "stair5"
	CREATE game\obstacle[7] OF Object
	LET game\obstacle[7]\x = 7077
	LET game\obstacle[7]\y = 340
	LET game\obstacle[7]\width = 64
	LET game\obstacle[7]\height = 64
	LET game\obstacle[7]\color = "#804040"
	LET game\obstacle[7]\name = "stair6"
	CREATE game\obstacle[8] OF Object
	LET game\obstacle[8]\x = 5320
	LET game\obstacle[8]\y = 260
	LET game\obstacle[8]\width = 64
	LET game\obstacle[8]\height = 32
	LET game\obstacle[8]\color = "#804040"
	LET game\obstacle[8]\name = "block10"
	CREATE game\obstacle[9] OF Object
	LET game\obstacle[9]\x = 5460
	LET game\obstacle[9]\y = 260
	LET game\obstacle[9]\width = 64
	LET game\obstacle[9]\height = 32
	LET game\obstacle[9]\color = "#804040"
	LET game\obstacle[9]\name = "block11"
	CREATE game\obstacle[10] OF Object
	LET game\obstacle[10]\x = 5320
	LET game\obstacle[10]\y = 120
	LET game\obstacle[10]\width = 64
	LET game\obstacle[10]\height = 32
	LET game\obstacle[10]\color = "#804040"
	LET game\obstacle[10]\name = "block12"
	CREATE game\obstacle[11] OF Object
	LET game\obstacle[11]\x = 5837
	LET game\obstacle[11]\y = 260
	LET game\obstacle[11]\width = 64
	LET game\obstacle[11]\height = 32
	LET game\obstacle[11]\color = "#804040"
	LET game\obstacle[11]\name = "block13"
	CREATE game\obstacle[12] OF Object
	LET game\obstacle[12]\x = 6197
	LET game\obstacle[12]\y = 260
	LET game\obstacle[12]\width = 128
	LET game\obstacle[12]\height = 32
	LET game\obstacle[12]\color = "#804040"
	LET game\obstacle[12]\name = "block14"
	CREATE game\obstacle[13] OF Object
	LET game\obstacle[13]\x = 6077
	LET game\obstacle[13]\y = 100
	LET game\obstacle[13]\width = 256
	LET game\obstacle[13]\height = 32
	LET game\obstacle[13]\color = "#804040"
	LET game\obstacle[13]\name = "block15"
	CREATE game\obstacle[14] OF Object
	LET game\obstacle[14]\x = 7978
	LET game\obstacle[14]\y = 144
	LET game\obstacle[14]\width = 64
	LET game\obstacle[14]\height = 256
	LET game\obstacle[14]\color = "#804040"
	LET game\obstacle[14]\name = "stair3-1"
	CREATE game\obstacle[15] OF Object
	LET game\obstacle[15]\x = 8040
	LET game\obstacle[15]\y = 208
	LET game\obstacle[15]\width = 64
	LET game\obstacle[15]\height = 192
	LET game\obstacle[15]\color = "#804040"
	LET game\obstacle[15]\name = "stair3-2"
	CREATE game\obstacle[16] OF Object
	LET game\obstacle[16]\x = 8100
	LET game\obstacle[16]\y = 280
	LET game\obstacle[16]\width = 64
	LET game\obstacle[16]\height = 128
	LET game\obstacle[16]\color = "#804040"
	LET game\obstacle[16]\name = "stair3-3"
	CREATE game\obstacle[17] OF Object
	LET game\obstacle[17]\x = 8161
	LET game\obstacle[17]\y = 336
	LET game\obstacle[17]\width = 64
	LET game\obstacle[17]\height = 64
	LET game\obstacle[17]\color = "#804040"
	LET game\obstacle[17]\name = "stair3-4"
	CREATE game\obstacle[18] OF Object
	LET game\obstacle[18]\x = 380
	LET game\obstacle[18]\y = 258
	LET game\obstacle[18]\width = 64
	LET game\obstacle[18]\height = 32
	LET game\obstacle[18]\color = "#804040"
	LET game\obstacle[18]\name = "block1"
	CREATE game\obstacle[19] OF Object
	LET game\obstacle[19]\x = 524
	LET game\obstacle[19]\y = 258
	LET game\obstacle[19]\width = 320
	LET game\obstacle[19]\height = 32
	LET game\obstacle[19]\color = "#804040"
	LET game\obstacle[19]\name = "block2"
	CREATE game\obstacle[20] OF Object
	LET game\obstacle[20]\x = 660
	LET game\obstacle[20]\y = 120
	LET game\obstacle[20]\width = 64
	LET game\obstacle[20]\height = 32
	LET game\obstacle[20]\color = "#804040"
	LET game\obstacle[20]\name = "block3"
	CREATE game\obstacle[21] OF Object
	LET game\obstacle[21]\x = 3711
	LET game\obstacle[21]\y = 240
	LET game\obstacle[21]\width = 192
	LET game\obstacle[21]\height = 32
	LET game\obstacle[21]\color = "#804040"
	LET game\obstacle[21]\name = "block4"
	CREATE game\obstacle[22] OF Object
	LET game\obstacle[22]\x = 3911
	LET game\obstacle[22]\y = 120
	LET game\obstacle[22]\width = 256
	LET game\obstacle[22]\height = 32
	LET game\obstacle[22]\color = "#804040"
	LET game\obstacle[22]\name = "block5"
	CREATE game\obstacle[23] OF Object
	LET game\obstacle[23]\x = 4420
	LET game\obstacle[23]\y = 120
	LET game\obstacle[23]\width = 128
	LET game\obstacle[23]\height = 32
	LET game\obstacle[23]\color = "#804040"
	LET game\obstacle[23]\name = "block6"
	CREATE game\obstacle[24] OF Object
	LET game\obstacle[24]\x = 4484
	LET game\obstacle[24]\y = 250
	LET game\obstacle[24]\width = 64
	LET game\obstacle[24]\height = 32
	LET game\obstacle[24]\color = "#804040"
	LET game\obstacle[24]\name = "block7"
	CREATE game\obstacle[25] OF Object
	LET game\obstacle[25]\x = 4844
	LET game\obstacle[25]\y = 260
	LET game\obstacle[25]\width = 128
	LET game\obstacle[25]\height = 32
	LET game\obstacle[25]\color = "#804040"
	LET game\obstacle[25]\name = "block8"
	CREATE game\obstacle[26] OF Object
	LET game\obstacle[26]\x = 5180
	LET game\obstacle[26]\y = 260
	LET game\obstacle[26]\width = 64
	LET game\obstacle[26]\height = 32
	LET game\obstacle[26]\color = "#804040"
	LET game\obstacle[26]\name = "block9"
	CREATE game\obstacle[27] OF Object
	LET game\obstacle[27]\x = 3551
	LET game\obstacle[27]\y = 400
	LET game\obstacle[27]\width = 500
	LET game\obstacle[27]\height = 200
	LET game\obstacle[27]\color = "#800000"
	LET game\obstacle[27]\name = "ground2"
	CREATE game\obstacle[28] OF Object
	LET game\obstacle[28]\x = 4431
	LET game\obstacle[28]\y = 400
	LET game\obstacle[28]\width = 3225
	LET game\obstacle[28]\height = 200
	LET game\obstacle[28]\color = "#800000"
	LET game\obstacle[28]\name = "ground3"
	CREATE game\obstacle[29] OF Object
	LET game\obstacle[29]\x = 7978
	LET game\obstacle[29]\y = 400
	LET game\obstacle[29]\width = 2800
	LET game\obstacle[29]\height = 200
	LET game\obstacle[29]\color = "#800000"
	LET game\obstacle[29]\name = "ground4"
	CREATE game\obstacle[30] OF Object
	LET game\obstacle[30]\x = 0
	LET game\obstacle[30]\y = 399
	LET game\obstacle[30]\width = 3200
	LET game\obstacle[30]\height = 200
	LET game\obstacle[30]\color = "#800000"
	LET game\obstacle[30]\name = "ground"
	CREATE game\obstacle[31] OF Object
	LET game\obstacle[31]\x = 7402
	LET game\obstacle[31]\y = 336
	LET game\obstacle[31]\width = 64
	LET game\obstacle[31]\height = 64
	LET game\obstacle[31]\color = "#804040"
	LET game\obstacle[31]\name = "stair2-1"
	CREATE game\obstacle[32] OF Object
	LET game\obstacle[32]\x = 7465
	LET game\obstacle[32]\y = 272
	LET game\obstacle[32]\width = 64
	LET game\obstacle[32]\height = 128
	LET game\obstacle[32]\color = "#804040"
	LET game\obstacle[32]\name = "stair2-2"
	CREATE game\obstacle[33] OF Object
	LET game\obstacle[33]\x = 7529
	LET game\obstacle[33]\y = 208
	LET game\obstacle[33]\width = 64
	LET game\obstacle[33]\height = 192
	LET game\obstacle[33]\color = "#804040"
	LET game\obstacle[33]\name = "stair2-3"
	CREATE game\obstacle[34] OF Object
	LET game\obstacle[34]\x = 7592
	LET game\obstacle[34]\y = 144
	LET game\obstacle[34]\width = 64
	LET game\obstacle[34]\height = 256
	LET game\obstacle[34]\color = "#804040"
	LET game\obstacle[34]\name = "stair2-4"
	CREATE game\obstacle[35] OF Object
	LET game\obstacle[35]\x = 9026
	LET game\obstacle[35]\y = 200
	LET game\obstacle[35]\width = 256
	LET game\obstacle[35]\height = 32
	LET game\obstacle[35]\color = "#804040"
	LET game\obstacle[35]\name = "blockair"
	CREATE game\obstacle[36] OF Object
	LET game\obstacle[36]\x = 8626
	LET game\obstacle[36]\y = 272
	LET game\obstacle[36]\width = 128
	LET game\obstacle[36]\height = 128
	LET game\obstacle[36]\color = "#008000"
	LET game\obstacle[36]\name = "pipe"
	CREATE game\obstacle[37] OF Object
	LET game\obstacle[37]\x = 1300
	LET game\obstacle[37]\y = 271
	LET game\obstacle[37]\width = 128
	LET game\obstacle[37]\height = 128
	LET game\obstacle[37]\color = "#004000"
	LET game\obstacle[37]\name = "largeobstacle1"
	CREATE game\obstacle[38] OF Object
	LET game\obstacle[38]\x = 2000
	LET game\obstacle[38]\y = 261
	LET game\obstacle[38]\width = 128
	LET game\obstacle[38]\height = 138
	LET game\obstacle[38]\color = "#004000"
	LET game\obstacle[38]\name = "largeobstacle2"
	CREATE game\obstacle[39] OF Object
	LET game\obstacle[39]\x = 2692
	LET game\obstacle[39]\y = 261
	LET game\obstacle[39]\width = 128
	LET game\obstacle[39]\height = 138
	LET game\obstacle[39]\color = "#004000"
	LET game\obstacle[39]\name = "largeobstacle3"

ENDSUB
