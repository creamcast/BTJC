//change function names so they start with BLOCK

function BLOCKMOVE(divid$, x, y, width, height) {
	mode = 1;
	if(width == undefined){ mode = 0; }
	if(height == undefined){ mode = 0; }

	var d = document.getElementById(divid$);
	d.style.position = "absolute";
	d.style.left = x;
  	d.style.top = y;
	
	if ( mode == 1 ){
		d.style.width = width
		d.style.height = height
	}
}

//BLOCK DIV EDITING http://javascriptist.net/docs/samples_element_style.html
function BLOCKCOLOR(divid$, color) {
	var d = document.getElementById(divid$);
	d.style.backgroundColor = color; 
}

function BLOCKIMAGE(divid$, url$, norepeat) {
	var d = document.getElementById(divid$);
	d.style.backgroundImage = "url(" + url$ + ")";
	
	if ( norepeat != undefined ){
		d.style.backgroundRepeat = 'no-repeat';
	} 
	//element.style.backgroundPosition = 'right bottom'; 
}

function BLOCKBORDER(divid$, size, color ){
	var d = document.getElementById(divid$);
	d.style.border = "solid " + size + "px " + color; 
}

function BLOCKTEXTCOLOR(divid$, color){
	var element = document.getElementById(divid$); 
	element.style.color = color; 
}

function CREATEBLOCK( divid$ ){
	//doesn't work
	var ndiv = null;
	ndiv = document.createElement("div");
	ndiv.id = divid$

	document.getElementsByTagName('body')[0].appendChild(ndiv);
}
