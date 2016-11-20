require.config({
  baseUrl: "/",
  paths: {
    underscore: "js/underscore-1.8.3",
    Backbone: "js/backbone",
    jquery: "js/jquery.min-2.1.4",
    TEXT: "js/text-2.0.14",
    Util: "js/util",
    Tweet: "js/model/tweet.model",
    Timeline: "js/model/timeline.model",
    Followings: "js/model/followings.model",
    Followers: "js/model/followers.model",
    Likes: "js/model/likes.model",
    User: "js/model/user.model",
    ProfileView: "js/profile/profile.view"
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

  $("#follow").click(function() {
    var target_user_id = parseInt($("#profile_id").val());
    var type = $("#follow").attr("action");
    $.ajax({
      type: type == "follow" ? 'post' : 'delete',
      url: '/api/v1/follows',
      contentType: 'application/json;charset=utf-8',
      dataType: 'json',
      data: JSON.stringify({following_id: target_user_id}),
      success: function() {
        $("#follow").attr("action", type == "follow" ? "unfollow" : "follow");
        $("#follow").text(type == "follow" ? "Following" : "Follow");
      },
      error: function() {
        console.log("Error: when clicking " + type + ".");
      }
    })
  });

  require(['ProfileView'], function(ProfileView) {
    var user_id = parseInt($("#profile_id").val());
    var profile_view = new ProfileView(user_id);
    profile_view.goto_tweets();

  })

})
