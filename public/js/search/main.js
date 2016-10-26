require.config({
  baseUrl: "/",
  paths: {
    underscore: "js/underscore-1.8.3",
    Backbone: "js/backbone",
    jquery: "js/jquery.min-2.1.4",
    TEXT: "js/text-2.0.14",
    Util: "js/util",
    Tweet: "js/model/tweet.model",
    User: "js/model/user.model",
    SearchUsers: "js/model/searchusers.model",
    SearchTweets: "js/model/searchtweets.model",
    ResultView: "js/search/result.view",
  },
  waitSeconds: 10
})

require(['Util'], function(Util) {
  $("#logout").click(function() {
    Util.delCookie("access_token");
    window.location = "/";
  });

  $("#search").click(function() {
    keyword = $("#search_keyword").val();
    if (keyword.length > 0) {
      window.location = "/search?keyword=" + keyword;
    }
  });

  $("#user-menu").click(function() {
    var menu = $("#user-menu");
    if (menu.hasClass("open"))
      menu.removeClass("open");
    else
      menu.addClass("open");
  });

  require(['ResultView'], function(ResultView) {
    var keyword = $("#keyword").text();
    //not support hastag search now.
    var result_view = new ResultView(keyword);
    result_view.search_on_users();
  });

});
