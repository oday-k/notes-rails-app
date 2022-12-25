class NotificationMailer < ApplicationMailer
  default from: 'notes-app@example.com'

  def share_notification
    @owner = params[:owner]
    @note  = params[:note]
    mail(to: params[:user].email, subject: 'New Note Shared')
  end
end
