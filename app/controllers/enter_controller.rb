class EnterController < ActionController::Base
  layout "application"
  caches_page :sign_in, :sign_up, :oferta

  def sign_in
  end

  def sign_up
    redirect_to "/payment?type=#{params[:type_reg]}" if params[:type_reg].present?
  end

  def sign_out
    session[:user_key] = nil
    redirect_to "/"
  end

  def oferta
  end
end
