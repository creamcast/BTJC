function ASC(str$){
	return str$.charCodeAt(0);
}

function CHR(num){
	return String.fromCharCode(num);
}

function LEN(str$){
	return str$.length;
}

function CHARAT(str$, n){
	n = n - 1;
	return str$.charAt(n);
}

function MID(str$, f, n){ 
	f = f - 1;
	if (n == undefined){
		return str$.substr(f);
	}else{
		return str$.substr(f , n);
	}
}

function FINDSTR(str$, findstr$){
	var n = str$.search(findstr$);
	return n + 1;
}

function LEFT(str$, n){
	return str$.substring(0, n);
}

function RIGHT(str$, n){
	return str$.substr(str$.length - n, n)
}

function REPLACESTR(str$, find$, replace$){
	//return str$.replace(find$, replace$);  //one occurence
	return str$.replace(new RegExp(find$, 'g'), replace$);
}

function SPACE(num){
	var string = "";
	for (var i=1 ; i<=num ; i++){
		//string = string + "&nbsp;";
		string = string + " ";
	}
	return string;
}

function REVERSE(str$){
	return str$.split('').reverse().join('');
}

function UCASE(str$){
	return str$.toUpperCase();
}

function LCASE(str$){
	return str$.toLowerCase();
}