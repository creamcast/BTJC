function HTMLGET(b,c){var a=new XMLHttpRequest;a.onreadystatechange=function(){a.readyState==a.DONE&&200==a.status&&c(a.responseText)};a.open("GET",b);a.send()};
