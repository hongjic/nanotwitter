require.config({
  baseUrl: "../",
  paths: {
    underscore: "js/underscore-1.8.3",
    Backbone: "js/backbone.min-1.2.3",
    Bootstrap: "js/bootstrap.min",
    jquery: "js/jquery.min-2.1.4",
    TEXT: "js/text-2.0.14",
    Tweet: "js/home/tweet.model",
    Tweets: "js/home/tweets.model",
    HomeLineView: "js/home/homeline.view",
  },
  waitSeconds: 10
})

// function tweet(content) {
//   data = {content: content};
//   $.ajax({
//     type: "post",
//     url: "/api/v1/tweets",
//     dataType: "json",
//     data: data,
//     success: function(result) {
//       if (result.resultCode == "success") {
//         //TODO: change to data-driven
//         window.location = "/";
//       }
//       else alert(result.resultMsg);
//     },
//     error: function(xhr, status, errorThrown) {
//       if (status = 401)
//         window.location = "/login.html";
//     }
//   })
// }

// $("#tweet_submit").click(function() {
//   content = $("#tweet_content").val();
//   tweet(content);
// })
$("#logout").click(function() {
  document.cookie = "access_token="
  window.location = "/"
});
require(['HomeLineView'], function(HomeLineView) {
  var homeline_view = new HomeLineView();
  homeline_view.query();
});