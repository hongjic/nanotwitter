define(['jquery'], function() {
  var get_time_distance = function(previous, current) {
    d = parseInt((current - previous) / 1000);
    if (parseInt(d/3600/24) > 0) {
      dd = parseInt(d/3600/24);
      return dd.toString() + (dd == 1 ? " day" : " days");
    }
    else if (parseInt(d/3600) > 0) {
      dd = parseInt(d/3600);
      return dd.toString() + (dd == 1 ? " hour" : " hours");
    }
    else if (parseInt(d/60) > 0) {
      dd = parseInt(d/60);
      return dd.toString() + (dd == 1 ? " minute" : " minutes");
    }
    else return d.toString() + (d == 1 ? "second" : " seconds");
  };

  var setCookie = function(name, value){
    var exp  = new Date();  
    exp.setTime(exp.getTime() + 30*24*60*60*1000);
    document.cookie = name + "=" + escape (value) + ";expires=" + exp.toGMTString() + ";path=/";
  };

  var getCookie = function(name){
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
    if(arr != null) return unescape(arr[2]); return null;
  };
  
  var delCookie = function(name){
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval=getCookie(name);
    if(cval!=null) document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString() + ";path=/";
  };

  return {
    get_time_distance: get_time_distance,
    setCookie: setCookie,
    getCookie: getCookie,
    delCookie: delCookie
  }
  
})