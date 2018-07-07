function RND(max, min){

	if ( min === undefined) {
		min = 0;
	}
	
	return Math.floor(Math.random() * (max - min + 1)) + min;
}

function COS(num){
	return Math.cos(num);
}

function SIN(num){
	return Math.sin(num);
}

function TAN(num){
	return Math.tan(num);
}

function ACOS(num){
	return Math.acos(num);
}

function ABS(num){
	return Math.abs(num);
}

function ATAN(num){
	return Math.atan(num);
}

function ATAN2(y, x){
	return Math.atan2(y,x);
}

function ROUNDUP(num){
	return Math.ceil(num);
}

function ROUNDDOWN(num){
	return Math.floor(num);
}

function ROUND(num){
	return Math.round(num);
}

function EXP(num){
	return Math.exp(num);
}

function LOG(num){
	return Math.log(num);
}

function POW(num, power){
	return Math.pow(num, power);
}

function SQR(num){
	return Math.sqrt(num);
}

function PI(){
	return Math.PI;
}