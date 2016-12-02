define(['jquery'], function() {
  var get_time_distance = function(previous, current) {
    d = Math.floor((current - previous) / 1000);
    if (Math.floor(d/3600/24/365) > 0) {
      dd = Math.floor(d/3600/24/365);
      return dd.toString() + (dd == 1 ? " year" : " years");
    }
    if (Math.floor(d/3600/24/30) > 0) {
      dd = Math.floor(d/3600/24/30);
      return dd.toString() + (dd == 1 ? " month" : " months");
    }
    if (Math.floor(d/3600/24/7) > 0) {
      dd = Math.floor(d/3600/24/7);
      return dd.toString() + (dd == 1 ? " week" : " weeks");
    }
    if (Math.floor(d/3600/24) > 0) {
      dd = Math.floor(d/3600/24);
      return dd.toString() + (dd == 1 ? " day" : " days");
    }
    else if (Math.floor(d/3600) > 0) {
      dd = Math.floor(d/3600);
      return dd.toString() + (dd == 1 ? " hour" : " hours");
    }
    else if (Math.floor(d/60) > 0) {
      dd = Math.floor(d/60);
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

  function CacheManager() {
    this.put = function(key, value) {
      localStorage.setItem(key, JSON.stringify(value));
    }
    this.get = function(key) {
      _value = localStorage.getItem(key);
      if (_value == null) 
        return null;
      return JSON.parse(_value);
    }
    this.remove = function(key) {
      _value = localStorage.getItem(key);
      if (_value == null) 
        return false;
      localStorage.removeItem(key);
      return JSON.parse(_value);
    }
  }


  return {
    get_time_distance: get_time_distance,
    setCookie: setCookie,
    getCookie: getCookie,
    delCookie: delCookie,
    cacheManager: new CacheManager()
  }
  
})