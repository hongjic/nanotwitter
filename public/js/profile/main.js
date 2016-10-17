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

  $("#follow").click(function() {
    var target_user_id = parseInt($("#profile_id").val());
    $.ajax({
      type: 'post',
      url: '/api/v1/follows',
      contentType: 'application/json;charset=utf-8',
      dataType: 'json',
      data: JSON.stringify({following_id: target_user_id}),
      success: function() {
        $("#follow").text("Following");
        document.getElementById("follow").id = "unfollow";
      },
      error: function(xhr, status, error){
        console.log("Error: when adding a follow relationship.");
      }
    });
  });

  $("#unfollow").click(function() {
    var target_user_id = parseInt($("#profile_id").val());
    $.ajax({
      type: 'delete',
      url: '/api/v1/follows',
      contentType: 'application/json;charset=utf-8',
      dataType: 'json',
      data: JSON.stringify({following_id: target_user_id}),
      success: function() {
        $("#unfollow").text("Follow");
        document.getElementById("unfollow").id = "follow";
      },
      error: function() {
        console.log("Error: when deleting a follow relationship.");
      }
    });
  });

  require(['ProfileView'], function(ProfileView) {
    var profile_view = new ProfileView();

  })

})
