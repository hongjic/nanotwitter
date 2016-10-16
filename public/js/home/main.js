require.config({
  baseUrl: "../",
  paths: {
    underscore: "js/underscore-1.8.3",
    Backbone: "js/backbone",
    Bootstrap: "js/bootstrap.min",
    jquery: "js/jquery.min-2.1.4",
    TEXT: "js/text-2.0.14",
    Util: "js/util",
    Tweet: "js/home/tweet.model",
    Tweets: "js/home/tweets.model",
    HomeLineView: "js/home/homeline.view",
  },
  waitSeconds: 1
})

$("#logout").click(function() {
  document.cookie = "access_token="
  window.location = "/"
});

require(['HomeLineView'], function(HomeLineView) {
  var homeline_view = new HomeLineView();
  homeline_view.query();
});