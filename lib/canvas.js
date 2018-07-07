//Canvas lib
globalcanvas = null;
global_last_text_height = 0;

function SETCANVAS(elementid){
    var canvas = document.getElementById(elementid);
	var ctx = canvas.getContext('2d');
    globalcanvas = ctx;
}

function SETFONT(size, name){
    str = size + "pt " + name;
    global_last_text_height = size * 1.5;
	globalcanvas.font = str;
}

function TEXT(x, y, text){
    globalcanvas.fillText(text, x, y);
}

function TEXTWIDTH(str){
	return globalcanvas.measureText(str).width;
}

function LINE(x, y, x2, y2) {
	globalcanvas.beginPath();
    globalcanvas.moveTo(x, y);
	globalcanvas.lineTo(x2, y2);
	globalcanvas.stroke();
}

function FILLRECT(x, y, w, h) {
    globalcanvas.fillRect(x, y, w, h);
}

function RECT(x, y, w, h) {
	globalcanvas.strokeRect(x, y, w, h);
}

function CLEARRECT(x, y, w, h) {
    globalcanvas.clearRect(x, y, w, h);
}

function CIRCLE(x, y, radius) {
	globalcanvas.beginPath();
	globalcanvas.arc(x, y, radius, 0, Math.PI*2, false);
	globalcanvas.stroke();
}

function FILLCIRCLE( x, y, radius) {
	globalcanvas.beginPath();
	globalcanvas.arc(x, y, radius, 0, Math.PI*2, false);
	globalcanvas.fill();
}

function COLOR( color) {
	globalcanvas.fillStyle = color;
}

function STROKE( color) {
	globalcanvas.strokeStyle = color;
}

function LOADIMAGE(imagesrc) {
	var img = new Image();
	img.src = imagesrc
	return img;
}

function IMAGE( img, x, y, w, h) {
	var mode = 0;
	
	if ( w === undefined) {
		mode = 1;
	}
	
	if ( h === undefined) {
		mode = 1;
	}
    
	if ( img.complete ){
		if ( mode === 1) { globalcanvas.drawImage(img, x, y); }
		if (mode === 0) { globalcanvas.drawImage(img, x, y, w, h); }
	}else{
		
		img.onload = function() {
			//document.getElementById('main').innerHTML+="IMAGE LOADED";
			if ( mode === 1) {globalcanvas.drawImage(img, x, y); }
			if (mode === 0) { globalcanvas.drawImage(img, x, y, w, h); }
		};
	}
}

function IMAGEWIDTH(img) {
	return img.width;
}

function IMAGEHEIGHT(img) {
	return img.height;
}

function CHECKIMAGE(img) {
	if ( img == undefined ){
		return false;
	}
    
    if (!img.complete) {
        return false;
    }
    
    if (typeof img.naturalWidth != "undefined" && img.naturalWidth == 0) {
        return false;
    }
    
	return true;
}

function GETIMAGEDATA( sx, sy, sw, sh){
	return globalcanvas.getImageData(sx, sy, sw, sh)
}
function PUTIMAGEDATA( imgdata, x, y){
	return globalcanvas.putImageData(imgdata, x, y);
}

function SLICEDIMAGE( img, sx, sy, sw, sh, dx, dy, dw, dh) {
	if ( img.complete ){
		globalcanvas.drawImage(img, sx, sy, sw, sh, dx, dy, dw, dh);
	}else{
		img.onload = function() {
			//document.getElementById('main').innerHTML+="IMAGE LOADED";
			globalcanvas.drawImage(img, sx, sy, sw, sh, dx, dy, dw, dh);
		};
	}
}

function GLOBALALPHA( a) {
	globalcanvas.globalAlpha = a;
}

function RGB(r, g, b) {
	var str$ = "rgb(" + r + "," + g + "," + b + ")";
	return str$;
}

function RGBA(r, g, b, a) {
	var str$ = "rgba(" + r + "," + g + "," + b + "," + a + ")";
	return str$;
}

function SETSMOOTHING( value){
	globalcanvas.imageSmoothingEnabled = value;
}
