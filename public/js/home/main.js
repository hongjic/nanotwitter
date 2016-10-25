require.config({
  baseUrl: "/",
  paths: {
    underscore: "js/underscore-1.8.3",
    Backbone: "js/backbone",
    jquery: "js/jquery.min-2.1.4",
    TEXT: "js/text-2.0.14",
    Util: "js/util",
    Tweet: "js/model/tweet.model",
    HomeLine: "js/model/homeline.model",
    HomeLineView: "js/home/homeline.view",
  },
  waitSeconds: 10
})

require(['Util'], function(Util) {

  $("#logout").on("click touchend", function(event) {
    event.preventDefault();
    event.stopPropagation();
    Util.delCookie("access_token");
    window.location = "/";
  });

  $("#search").on("click touchend", function(event) {
    event.preventDefault();
    event.stopPropagation();
    keyword = $("#search_keyword").val();
    if (keyword.length > 0) {
      window.location = "/search?keyword=" + keyword;
    }
  });

  require(['HomeLineView'], function(HomeLineView) {
    var homeline_view = new HomeLineView();
    homeline_view.query();
  });
})
