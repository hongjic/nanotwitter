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
  }

  return {
    get_time_distance: get_time_distance
  }
})