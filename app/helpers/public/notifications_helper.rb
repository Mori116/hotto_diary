module Public::NotificationsHelper

    def notification_form(notification)
      @visitor = notification.visitor
      @comment = nil
      @visiter_comment = notification.diary_comment_id
      #notification.actionがcommentである場合
      case notification.action
        when "comment" then
          @comment = DiaryComment.find_by(id: @visiter_comment)&.comment
          tag.a(@visitor.nickname, style: "font-weight: bold;")+"が"+tag.a('あなたの日記', href: group_diary_path(notification.diary.group_id, notification.diary_id), style: "font-weight: bold;")+"にコメントしました"
      end
    end

end
