function STOPWCALL(identifier){
	clearTimeout(identifier);
}

function STOPREPEAT(identifier){
    clearInterval(identifier);
}

function UNIXTIME(){
	time = new Date();
	return time.getTime();
}

function USERAGENT(){
	var uagent = navigator.userAgent.toLowerCase();
	return uagent;
}

function BGCOLOR(color){
	document.body.style.background = color;
}

function DATE(){
	var nowtime = Date.now();
	return nowtime;
}

function RELOADPAGE(){
	document.location.reload(true);
}
