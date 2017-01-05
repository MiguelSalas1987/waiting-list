# Preview all emails at http://localhost:3000/rails/mailers/request_mailer
class RequestMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/request_mailer/email_confirmation
  def email_confirmation
    request = Request.first
    request.confirmation_token =Request.new_token
    RequestMailer.email_confirmation(request)
  end

end
