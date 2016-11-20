define(['Backbone', 'underscore', 'SearchUsers', 'SearchTweets', 'Util', 'TEXT!js/search/users_result.tpl.html', 'TEXT!js/search/tweets_result.tpl.html'],
  function(Backbone, _, SearchUsers, SearchTweets, Util, UsersResultTpl, TweetsResultTpl) {

  var ResultView = Backbone.View.extend({
    el: "#search_result",

    events: {
      'click #search_users': 'search_on_users',
      'click #search_tweets': 'search_on_tweets',
      'click .reply': 'reply',
      'click .likes': 'likes'
    },

    template_users: _.template(UsersResultTpl),
    template_tweets: _.template(TweetsResultTpl),

    initialize: function(keyword) {
      this.set_keyword(keyword);
      this.search_users = new SearchUsers();
      this.search_tweets = new SearchTweets();
      this.listenTo(this.search_users, "sync", this.render_users);
      this.listenTo(this.search_tweets, "sync", this.render_tweets);
    },

    set_keyword: function(keyword) {
      if (!this.keyword || this.keyword != keyword) {
        this.keyword = keyword;
        this.first_time_users = true;
        this.first_time_tweets = true;
      }
    },

    query_users: function() {
      var that = this;
      this.search_users.fetch({
        data: {
          keyword: that.keyword,
          fields: ["id", "name", "email"]
        },
        success: function(collection, resp, options) {
          that.first_time_users = false;
        },
        error: function(collection, resp, options) {
          window.location = "/login.html";
        }
      });
    },

    query_tweets: function() {
      var that = this;
      this.search_tweets.fetch({
        data: {
          keyword: that.keyword
        },
        success: function(collection, resp, options) {
          that.first_time_tweets = false;
        },
        error: function(collection, resp, options) {
          window.location = "/login.html";
        }
      });
    },

    search_on_users: function() {
      if (this.first_time_users) {
        this.query_users();
      }
      else this.render_users();
    },

    search_on_tweets: function() {
      if (this.first_time_tweets) {
        this.query_tweets();
      }
      else this.render_tweets();
    },

    render_users: function() {
      this.$el.html(this.template_users({users: this.search_users.toJSON()}));
    },

    render_tweets: function() {
      this.$el.html(this.template_tweets({tweets: this.search_tweets.toJSON()}));
    },

    reply: function() {

    },

    likes: function() {
      var ele = event.target;
      var tweet_index = $(ele).parents(".media").siblings().length - $(ele).parents(".media").index();
      var search_tweets = this.search_tweets;
      var tweetid = parseInt($(ele).attr("tweetid"));
      var is_favored = $(ele).hasClass("btn-primary");
      $.ajax({
        url: "/api/v1/likes",
        type: (is_favored ? "delete" : "post"),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        data: JSON.stringify({tweet_id: tweetid}),
        success: function(result) {
          favors = result.resultMsg.favors;
          // update the model
          search_tweets.at(tweet_index).set("favors", favors);
          search_tweets.at(tweet_index).set("is_favored", !is_favored);
          // update the html
          $(ele).html("Likes " + (favors > 0 ? favors.toString() : ""));
          if (is_favored) $(ele).removeClass("btn-primary").addClass("btn-default");
          else $(ele).removeClass("btn-default").addClass("btn-primary");
        },
        error: function() {
          console.log("error likes");
        }
      })
    }    

  });

  return ResultView;

});