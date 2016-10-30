define(['Backbone', 'underscore', 'Timeline', 'Followings', 'Followers', 'Util', 'TEXT!js/profile/tweet_list.tpl.html', 'TEXT!js/profile/user_list.tpl.html'], 
  function(Backbone, _, Timeline, Followings, Followers, Util, TweetTpl, UserTpl) {

  var btn_list = ["profile_tweets", "profile_likes", "profile_followings", "profile_followers"];

  var ProfileView = Backbone.View.extend({
    el: '#profile_content',

    events: {
      'click .reply': 'reply',
      'click .likes': 'likes',
      'click #profile_tweets': 'goto_tweets',
      'click #profile_likes': 'goto_likes',
      'click #profile_followings': 'goto_followings',
      'click #profile_followers': 'goto_followers'
    },

    tweet_template: _.template(TweetTpl),
    user_template: _.template(UserTpl),

    initialize: function(user_id) {
      this.user_id = user_id;
    },

    render_tweets: function() {
      this.$el.html(this.tweet_template({time_line: this.timeline.toJSON(), type: "tweets"}));
    },

    render_followings: function() {
      this.$el.html(this.user_template({users: this.followings.toJSON(), type: "followings"}));
    },

    render_followers: function() {
      this.$el.html(this.user_template({users: this.followers.toJSON(), type: "followers"}));
    },

    query: function(type) {
      var model;
      if (type == "tweets")
        model = this.timeline;
      else if (type == "followings")
        model = this.followings;
      else if (type == "followers")
        model = this.followers;
      model.fetch({
        success: function(collection, resp, options) {
          console.log("success");
        },
        error: function(collection, resp, options) {
          window.location = "/login.html";
        }
      })
    },

    reply: function() {
      // TODO:
    },

    likes: function() {
      // TODO:
    },

    goto_tweets: function() {
      if (this.timeline == null) {
        this.timeline = new Timeline(this.user_id);
        this.listenTo(this.timeline, 'sync', this.render_tweets);
        this.query("tweets");
      }
      else this.render_tweets();
    },

    goto_followings: function() {
      if (this.followings == null) {
        this.followings = new Followings(this.user_id);
        this.listenTo(this.followings, 'sync', this.render_followings);
        this.query("followings");
      }
      else this.render_followings();
    },

    goto_followers: function() {
      if (this.followers == null) {
        this.followers = new Followers(this.user_id);
        this.listenTo(this.followers, 'sync', this.render_followers);
        this.query("followers");
      }
      else this.render_followers();
    },

  });

  return ProfileView;

});