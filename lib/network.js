//XMLHTTPREQUEST
function HTMLGET(url$, callback){
	var request = new XMLHttpRequest();

	request.onreadystatechange = function() {
    if( request.readyState == request.DONE && request.status == 200 ) {        
        callback(request.responseText);
    }
	};

	request.open('GET', url$);
	request.send();
}