global_cdiv = null;
global_timer = null;
global_keydown = null;
global_init_keyboard = 0;

var glbl_keys = new Array();

var touchinfo = new Object();
touchinfo.touches = new Array();
touchinfo.touches[0] = new Object();
touchinfo.touches[1] = new Object();
touchinfo.touches[2] = new Object();
touchinfo.touches[3] = new Object();
touchinfo.touches[4] = new Object();
touchinfo.touches[5] = new Object();
touchinfo.touches[0].pageX = 0
touchinfo.touches[0].pageY = 0
touchinfo.touches[1].pageX = 0
touchinfo.touches[1].pageY = 0
touchinfo.touches[2].pageX = 0
touchinfo.touches[2].pageY = 0
touchinfo.touches[3].pageX = 0
touchinfo.touches[3].pageY = 0
touchinfo.touches[4].pageX = 0
touchinfo.touches[4].pageY = 0
touchinfo.touches[5].pageX = 0
touchinfo.touches[5].pageY = 0

var mouseinfo = new Object();

//keyboard
function INITKEYBOARD(){

	if (global_init_keyboard == 0) {
	
		document.addEventListener('keydown', function (event) {
			global_keydown = event.keyCode;
			glbl_keys[event.keyCode] = 1;
		}, true);
		
		document.addEventListener('keyup', function (event) {
		
			if( glbl_keys[event.keyCode] == 1){
				glbl_keys[event.keyCode] = 0;
			}
			
			if( global_keydown == event.keyCode){
				global_keydown = 0;
			}
		}, true);
		
		global_init_keyboard = 1;
	}
}

function INITMOUSE(){
	document.addEventListener("mousemove", mouseHandler, false);
	
	document.onmousedown = function(e){
		mouseinfo.down = 1;
	}
	
	document.onmouseup = function(e){
		mouseinfo.down = 0;
	}
	
}

function mouseHandler(e) {
	mouseinfo.clientX = e.clientX;
	mouseinfo.clientY = e.clientY;
	mouseinfo.screenX = e.screenX;
	mouseinfo.screenY = e.screenY;
}

function INITTOUCH(){
	if ("ontouchstart" in window) {
		document.addEventListener("touchstart", touchHandler, false);
		document.addEventListener("touchmove", touchHandler, false);
		document.addEventListener("touchend", touchHandler, false);
		document.addEventListener("touchcancel", touchHandler, false);
	}
}

function INITTOUCHNEW(){
	document.addEventListener("touchstart", touchHandler, false);
	document.addEventListener("touchmove", touchHandler, false);
	document.addEventListener("touchend", touchHandler, false);
	document.addEventListener("touchcancel", touchHandler, false);
}

function LOADSOUND(filename){
	var soundobj = new Object();
	soundobj.sound = new Audio(filename)
	soundobj.state = 0

	soundobj.sound.load();
	
	return soundobj;
}

function PLAYSOUND(soundobj){

	if (soundobj.state = 1){
		soundobj.sound.play();
	} else {
		soundobj.sound.loadeddata = function() {
			soundobj.sound.play();
			soundobj.state = 1
		};
	}
}

function setTouches(e) {
    if( e.touches.length == 1  ) {
        touchinfo.touches[1].pageX = e.touches[0].pageX;
        touchinfo.touches[1].pageY = e.touches[0].pageY;
    }
    
    if( e.touches.length == 2 ) {
        touchinfo.touches[2].pageX = e.touches[1].pageX;
        touchinfo.touches[2].pageY = e.touches[1].pageY;
    }
    
    if( e.touches.length == 3 ) {
        touchinfo.touches[3].pageX = e.touches[2].pageX;
        touchinfo.touches[3].pageY = e.touches[2].pageY;
    }
    
    if( e.touches.length == 4 ) {
        touchinfo.touches[4].pageX = e.touches[3].pageX;
        touchinfo.touches[4].pageY = e.touches[3].pageY;
    }
    
    if( e.touches.length == 5 ) {
        touchinfo.touches[5].pageX = e.touches[4].pageX;
        touchinfo.touches[5].pageY = e.touches[4].pageY;
    }
}

function touchHandler(e) {
	e.preventDefault(); //prevent scroll and zoom etc
	switch (e.type) {
		case "touchstart" :
			touchinfo.total = e.touches.length;
            setTouches(e);
		break;
		case "touchmove" :
            setTouches(e);
        break;
		case "touchcancel" :
			touchinfo.total = e.touches.length;
		break;
		case "touchend" :
			touchinfo.total = e.touches.length;
		break;
  }
}

function GETKEY(){
	return global_keydown;
}

function KEYSTATE(num){
	return glbl_keys[num];
}

function GETVALID(targetid){
	var tmp = document.getElementById(targetid).value;
	return tmp.replace(/(<([^>]+)>)/ig,"");
}

function WINDOWWIDTH(){
	return window.innerWidth;
}

function WINDOWHEIGHT(){
	return window.innerHeight;
}

function SCREENHEIGHT(){
	return screen.availHeight;
}

function SCREENWIDTH(){
	return screen.availWidth;
}

//triggers
function TRIGGERMOUSEOVER(targetid, triggerfunc){
	document.getElementById(targetid).onmouseover = triggerfunc; 
}

function TRIGGERMOUSEDOWN(targetid, triggerfunc){
	document.getElementById(targetid).onmousedown = triggerfunc; 
}

function TRIGGERMOUSEUP(targetid, triggerfunc){
	document.getElementById(targetid).onmouseup = triggerfunc;
}

function TRIGGERMOUSEOUT(targetid, triggerfunc){
	document.getElementById(targetid).onmouseout = triggerfunc;
}

function TRIGGERWINDOWRESIZE(triggerfunc){
	window.onresize = triggerfunc;
}