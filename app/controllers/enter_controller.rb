class EnterController < ActionController::Base
  layout "application"
  caches_page :sign_in, :sign_up, :oferta

  def sign_in
  end

  def sign_up
  end

  def sign_out
    session[:user_key] = nil
    redirect_to "/"
  end

  def oferta
  end
end
