
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
    },

    likes: function() {
      //TODO:
    },

    input_change: function() {
      var input = this.$("#tweet_content").val();
      if (input.length < 5)
        this.$("#tweet_submit").attr("disabled", "disabled");
      else 
        this.$("#tweet_submit").removeAttr("disabled");
    }

  });

  return HomeLineView;

})