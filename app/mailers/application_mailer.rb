class ApplicationMailer < ActionMailer::Base
  default from: "ほっとダイアリー管理者 <#{ENV['SMTP_USER']}>"
  layout 'mailer'
end
