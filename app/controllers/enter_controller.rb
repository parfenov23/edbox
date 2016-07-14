class EnterController < ActionController::Base
  layout "application"
  require 'social/socials'
  caches_page :sign_in, :sign_up, :oferta

  def sign_in
  end

  def sign_up
    if params[:access_token].present?
      @info = Socials.reg_params(params[:type], params)
      user = User.find_by_email(@info[:email])
      redirect_to user.auth_url if user.present?
    end
    # redirect_to "/payment?type=#{params[:type_reg]}&page=reg" if params[:type_reg].present?
  end

  def sign_out
    session[:user_key] = nil
    redirect_to "/"
  end

  def oferta
  end
end
