
define(['Backbone', 'Tweet', 'HomeLine', 'Util','TEXT!js/home/tweet_list.tpl.html'], 
  function (Backbone, Tweet, HomeLine, Util, TweetListTpl) {
  var HomeLineView = Backbone.View.extend({
    el: '#home_line',

    events: {
      'click #tweet_submit': 'post_tweet',
      'click .reply': 'reply',
      'click .likes': 'likes',
      'input #tweet_content': 'input_change'
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

    post_tweet: function() {
      var content = this.$('#tweet_content').val();
      var new_tweet = new Tweet();
      var that = this;
      new_tweet.set({content: content});
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

    reply: function() {
      //TODO:
      console.log("reply");
    },

    likes: function(event) {
      var ele = event.target;
      var tweet_index = $(ele).parents(".media").siblings().length - $(ele).parents(".media").index();
      var homeline = this.homeline;
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