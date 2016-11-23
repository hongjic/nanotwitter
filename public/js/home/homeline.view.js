
define(['Backbone', 'Tweet', 'HomeLine', 'Util','TEXT!js/home/tweet_list.tpl.html'], 
  function (Backbone, Tweet, HomeLine, Util, TweetListTpl) {
  var HomeLineView = Backbone.View.extend({
    el: '#home_line',

    events: {
      'click #tweet_submit': 'normal_tweet',
      'click .reply': 'reply',
      'click .likes': 'likes',
      'input #tweet_content': 'input_change',
      'click #global_tweet_tweet': 'global_tweet_tweet',
      'click #global_tweet_cancel': 'global_tweet_cancel'
    },

    template: _.template(TweetListTpl),

    initialize: function() {
      this.homeline = new HomeLine();
      this.listenTo(this.homeline, 'update', this.render);
    },

    query: function() {
      this.homeline.fetch({
        success: function(collection, resp, options) {
          if (collection.length == 0)
            collection.trigger("update");
          console.log("success");
        },
        error: function(collection, resp, options) {
          window.location = '/login.html';
        }
      });
    },

    render: function() {
      this.$el.html(this.template({home_line: this.homeline.toJSON()}));
    },

    normal_tweet: function() {
      var content = this.$("#tweet_content").val();
      this.post_tweet({content: content});
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

    reply: function(event) {
      var ele = event.target;
      var user_name = $(ele).parents(".media").attr("username");
      this.reply_to_tweet_id = $(ele).parents(".media").attr("tweetid");
      title = "Reply to " + user_name;
      content = "@" + user_name
      this.global_tweet_create(title, content);
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
    },

    likes: function(event) {
      var ele = event.target;
      var tweet_index = $(ele).parents(".media").siblings().length - $(ele).parents(".media").index();
      var homeline = this.homeline;
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
          // update the model
          homeline.at(tweet_index).set("favors", favors);
          homeline.at(tweet_index).set("is_favored", !is_favored);
          // update the html
          $(ele).html("Likes " + (favors > 0 ? favors.toString() : ""));
          if (is_favored) $(ele).removeClass("btn-primary").addClass("btn-default");
          else $(ele).removeClass("btn-default").addClass("btn-primary");
        },
        error: function() {
          console.log("error likes");
        }
      })
    },

    input_change: function() {
      var input = this.$("#tweet_content").val();
      if (input.length < 5)
        this.$("#tweet_submit").attr("disabled", "disabled");
      else 
        this.$("#tweet_submit").removeAttr("disabled");
      if (input.length <= 140)
        this.$("#tweet_length").text(input.length.toString() + "/140");
      else {
        this.$("#tweet_content").val(input.substring(0, 140));
        this.$("#tweet_length").text("140/140");
      }
    }

  });

  return HomeLineView;

})