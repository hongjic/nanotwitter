define(['Backbone', 'underscore', 'Timeline', 'Followings', 'Followers', 'Likes', 'Util', 'TEXT!js/profile/tweet_list.tpl.html', 'TEXT!js/profile/user_list.tpl.html'], 
  function(Backbone, _, Timeline, Followings, Followers, Likes, Util, TweetTpl, UserTpl) {

  var btn_list = ["profile_tweets", "profile_likes", "profile_followings", "profile_followers"];

  var ProfileView = Backbone.View.extend({
    el: '#profile_content',

    events: {
      'click .reply': 'reply',
      'click .likes': 'likes',
      'click #profile_tweets': 'goto_tweets',
      'click #profile_likes': 'goto_likes',
      'click #profile_followings': 'goto_followings',
      'click #profile_followers': 'goto_followers',
      'click #global_tweet_tweet': 'global_tweet_tweet',
      'click #global_tweet_cancel': 'global_tweet_cancel'
    },

    tweet_template: _.template(TweetTpl),
    user_template: _.template(UserTpl),

    initialize: function(user_id) {
      this.user_id = user_id;
      this.timeline = new Timeline(this.user_id);
      this.listenTo(this.timeline, 'sync', this.render_tweets);
      this.followings = new Followings(this.user_id);
      this.listenTo(this.followings, 'sync', this.render_followings);
      this.followers = new Followers(this.user_id);
      this.listenTo(this.followers, 'sync', this.render_followers);
      this.liked_tweets = new Likes(this.user_id);
      this.listenTo(this.liked_tweets, 'sync', this.render_likes);
    },

    render_tweets: function() {
      this.$el.html(this.tweet_template({tweets: this.timeline.toJSON(), type: "tweets"}));
    },

    render_followings: function() {
      this.$el.html(this.user_template({users: this.followings.toJSON(), type: "followings"}));
    },

    render_followers: function() {
      this.$el.html(this.user_template({users: this.followers.toJSON(), type: "followers"}));
    },

    render_likes: function() {
      this.$el.html(this.tweet_template({tweets: this.liked_tweets.toJSON(), type: "likes"}));
    },

    query: function(type) {
      var model;
      if (type == "tweets")
        model = this.timeline;
      else if (type == "followings")
        model = this.followings;
      else if (type == "followers")
        model = this.followers;
      else if (type == "likes")
        model = this.liked_tweets
      model.fetch({
        success: function(collection, resp, options) {
          console.log("success");
        },
        error: function(collection, resp, options) {
          window.location = "/login.html";
        }
      })
    },

    reply: function(event) {
      var ele = event.target;
      var user_name = $(ele).parents(".media").attr("username");
      this.reply_to_tweet_id = $(ele).parents(".media").attr("tweetid");
      title = "Reply to " + user_name;
      content = "@" + user_name + " ";
      this.global_tweet_create(title, content);
    },

    likes: function() {
      var ele = event.target;
      var tweet_index = $(ele).parents(".media").siblings().length - $(ele).parents(".media").index();
      var tweets = (this.section == "tweets" ? this.timeline : this.liked_tweets);
      var tweetid = parseInt($(ele).parents(".media").attr("tweetid"));
      var is_favored = $(ele).hasClass("btn-primary");
      $.ajax({
        url: "/api/v1/likes",
        type: (is_favored ? "delete" : "post"),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        data: JSON.stringify({tweet_id: tweetid}),
        success: function(result) {
          favors = result.resultMsg.favors;
          tweets.at(tweet_index).set("favors", favors);
          tweets.at(tweet_index).set("is_favored", !is_favored);
          $(ele).html("Likes " + (favors > 0 ? favors.toString() : ""));
          if (is_favored) $(ele).removeClass("btn-primary").addClass("btn-default");
          else $(ele).removeClass("btn-default").addClass("btn-primary");
        },
        error: function() {
          console.log("error likes");
        }
      })
    },

    goto_tweets: function() {
      this.query("tweets");
      this.section = "tweets";
    },

    goto_followings: function() {
      this.query("followings");
      this.section = "followings";
    },

    goto_followers: function() {
      this.query("followers");
      this.section = "followers";
    },

    goto_likes: function() {
      this.query("likes");
      this.section = "likes";
    },

    post_tweet: function(tweet_info) {
      var new_tweet = new Tweet();
      var that = this;
      new_tweet.set(tweet_info);
      new_tweet.save(null, {
        success: function(model, resp, options) {
          if (resp.resultCode == "success")
            that.homeline.add(model);
        },
        error: function(model, resp, options) {
          window.location = '/login.html';
        }
      })
    },

    global_tweet_create: function(title, content) {
      this.$("#global_tweet_title").text(title);
      this.$("#global_tweet_content").val(content);
      this.$("#global_tweet").show();
    },

    global_tweet_tweet: function() {
      var content = this.$("#global_tweet_content").val();
      var reply_to_tweet_id = this.reply_to_tweet_id;
      this.post_tweet({content: content, reply_to_tweet_id: reply_to_tweet_id});
    },

    global_tweet_cancel: function() {
      this.$("#global_tweet").hide();
    }


  });

  return ProfileView;

});