define(['Backbone', 'underscore', 'Tweet', 'Util'], function(Backbone, _, Tweet, Util) {

  var ProfileView = Backbone.View.extend({
    el: '#profile_content',

    events: {
      'click #unfollow': 'unfollow',
      'click #follow': 'follow'
    },

    initialize: function() {

    },

    follow: function() {
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
    },

    unfollow: function() {
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
    },
  });

  return ProfileView;

});