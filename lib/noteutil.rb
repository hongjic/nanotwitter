module NoteUtil

  # the active user add a new follow,
  # user_id, user_name belongs to the active user
  def create_follow_note user_id, user_name, target_user_id
    note_info = {
      target_user_id: target_user_id,
      type: "new_follower",
      new_follower_id: user_id,
      source_user_name: user_name
    }
    create_notification note_info
  end

  # tweet_id represents the new reply tweet.
  def create_reply_note tweet_id, user_name, target_user_id
    note_info = {
      target_user_id: target_user_id,
      type: "reply",
      tweet_id: tweet_id,
      source_user_name: user_name
    }
    create_notification note_info
  end

  # currently not supported
  # tweet_id represents the new tweet mentions target user
  def create_mention_note tweet_id, user_name, target_user_id
    note_info = {
      target_user_id: target_user_id,
      type: "mention",
      tweet_id: tweet_id,
      source_user_name: user_name
    }
    create_notification note_info
  end

  def create_notification note_info
    TaskProducer.instance.new_task("notification:create", "build", note_info)
  end

  # get notifications by user
  def get_notifications_by_userid user_id
    notes = []
    Notification.where(target_user_id: user_id).each { |note| notes.push note.to_json_obj }
    notes
  end
end