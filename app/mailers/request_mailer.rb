class RequestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.request_mailer.email_confirmation.subject
  #
  def email_confirmation(request)
    @request = request
    mail to: @request.email, subject: "Please confirm your request for our coworking space"
  end

  def email_reconfirmation(request, place)
    @request = request
    @place_in_waiting_list = place
    mail to: @request.email, subject: "Reconfirmation needed for your request in our coworking space"
  end
end
