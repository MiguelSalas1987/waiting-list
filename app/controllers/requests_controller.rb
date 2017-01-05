class RequestsController < ApplicationController
  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    if @request.save
      #request.sent_confirmation_email
      flash[:info] = "Please check your email in order to confirm your request."
      redirect_to new_request_url
    else
      render 'new'
    end
  end

  def show
  end

  def index
  end

  private
    def request_params
      params.require(:request).permit(:name, :email, :phone_number, :paragraph)
    end

end
