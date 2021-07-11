module Public::NotificationsHelper

    def notification_form(notification)
      @visitor = notification.visitor
      @comment = nil
      @your_diary = link_to 'あなたの投稿', group_diary_path(notification), style: "font-weight: bold;"
      @visiter_comment = notification.diary_comment_id
      #notification.actionがfollowかlikeかcommentか
      case notification.action
        when "comment" then
          @comment = DiaryComment.find_by(id: @visiter_comment)&.comment
          tag.a(@visitor.nickname, style: "font-weight: bold;")+"が"+tag.a('あなたの投稿', href: group_diary_path(notification.diary_id), style: "font-weight: bold;")+"にコメントしました"
      end
    end

end
