class EnterController < ActionController::Base
  layout "application"
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
