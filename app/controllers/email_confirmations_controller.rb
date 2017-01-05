class EmailConfirmationsController < ApplicationController

 def edit
  request = Request.find_by(email: params[:email])
  if request && request.authenticated?(:confirmation, params[:id] )
    request.confirm!
    flash[:success] = "Your request has been confirmed. We will have you in our wating list until we find a place for you."
    redirect_to request
  else
    #handle invalid link
  end
 end
end
