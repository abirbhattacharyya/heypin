// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function keyAllowed(e, validchars)
{
     var key='', keychar='';
     key = getKeyCode(e);
     if (key == null) return true;
     keychar = String.fromCharCode(key);
     keychar = keychar.toLowerCase();
     validchars = validchars.toLowerCase();
     if (validchars.indexOf(keychar) != -1)
        return true;
     if ( key==null || key==0 || key==8 || key==9 || key==13 || key==27 )
        return true;
     return false;
}
function removePrecisions(num)
{
    if(num % 1 == 0)
        return num;
    else
        return parseFloat(num).toFixed(2);
}
function checkDecimals(val) {
    y = val.split(/\./);
    num = val
    if(y.length>2)
        num = y[0] + "." + y[1]
    else if(y.length == 1)
        num =  val;
    return num
}

function getKeyCode(e)
{
     if (window.event)
        return window.event.keyCode;
     else if (e)
        return e.which;
     else
        return null;
}
function charCount(id,Div,num)
{
    var str=document.getElementById(id).value;
    if((num-str.length)<0)
    {
        document.getElementById(id).value=str.substring(0,num);str=document.getElementById(id).value;
    }
    var left_char=num-str.length
    document.getElementById(Div).innerHTML=left_char;
}
