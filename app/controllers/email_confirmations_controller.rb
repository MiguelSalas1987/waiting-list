class EmailConfirmationsController < ApplicationController

 def edit
  request = Request.find_by(email: params[:email])

  if request && request.authenticated?(:confirmation, params[:id] )
    request.confirm!
    flash[:success] = "Your request has been confirmed. We will have you in our wating list until we find a place for you."
  else
    #handle invalid link or error
    flash[:warning] = "something went wrong, please try again later."
  end
  redirect_to request
 end

 def reconfirm

  request = Request.find_by(email: params[:email])
  if request && request.authenticated?(:confirmation, params[:id] )

    if request.reconfirm!
      flash[:success] = "Your request has been reconfirmed. We will keep your place in the waiting list, we will contact you when we have a place for you."
    else
      flash[:warning] = "something went wrong, please try again later."
    end
    redirect_to request

  else

    #handle invalid link
    flash[:danger] = "the link you are trying to use is invalid."
    redirect_to request

  end
 end

end


