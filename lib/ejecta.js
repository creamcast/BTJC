constant_x_start_position = 5
constant_y_start_position = 15

global_x_text_position = constant_x_start_position;
global_y_text_position = constant_y_start_position;
global_last_text_width = 0;

function EJECTAINCLUDE(includefile){
	ejecta.include(includefile);
}

function DEVICEWIDTH(){
	return canvas.width;
}

function DEVICEHEIGHT(){
	return canvas.height;
}

function SETCANVASWIDTH(width){
	canvas.width = width;
}

function SETCANVASHEIGHT(height){
	canvas.height = height;
}

function SCALECANVASWIDTH(width){
	canvas.style.width = width;
}

function SCALECANVASHEIGHT(height){
	canvas.style.height = height;
}

function SETRETINA(value){
	canvas.retinaResolutionEnabled = value;
}

function SETMSAA(value){
	canvas.MSAAEnabled = value;
}

function MSAASAMPLES(num){
	canvas.MSAASamples = num;
}

function OPENURL(url, dialogtext){
	ejecta.openURL( url, dialogtext );
}

function USERINPUT(title, dialogtext, callback){
	ejecta.getText( title, dialogtext, function(text) {
                   callback(text);
                   });
}

function LOADFONT(filepath){
	ejecta.loadFont(filepath);
}

function DEVICE(){
	return navigator.userAgent;
}

function NETWORKSTATUS(){
	return navigator.onLine;
}
