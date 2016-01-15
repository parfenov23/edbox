module Money
  class PurseController < MoneyController
    #Пополнение счета
    def refill
      param_pay = ((session[:ym][:success] rescue false) ? 'success' : 'fail')
      unless session[:ym][:success]
        param_pay += '_money' if current_user.incoming_moneys.last.data["reason"] == "not-enough-funds"
      end
      redirect_to "/courses?pay=" + param_pay
    end

    def refill_process
      subscription = create_subscription(params)
      session[:ym] = {}
      amount = $env_mode.dev? ? 1 : ($env_mode.beta? ? 100 : params[:sum])
      # Инициализация модуля Яндекс Деньги
      ym = YandexMoneyHelper::YM.new
      not_ym_successful(ym) if !ym.successful
      # Прием платежа на кошелек Яндекс Денег
      res = ym.recieve_payment(amount, "#{current_user.full_name}(#{current_user.email})")
      not_ym_successful(ym) if !ym.successful
      # Требуется внешняя аутентификация пользователя
      not_ym_successful(res) if res.status != "ext_auth_required"
      # Сохраняем проверочный код платежа в сессии
      session[:ym][:secure_code] = ym.secure_code
      session[:ym][:amount] = amount
      session[:ym][:subscription] = subscription.id

      # Отсылаем методом POST acs_params:
      @acs_params = res.acs_params
      @acs_uri = res.acs_uri
    end

    def payment_fail
      session[:ym][:success] = false
      Subscription.find(session[:ym][:subscription]).destroy rescue nil
      IncomingMoney.create(:user => current_user, :data => params.to_h )
      session[:ym][:subscription] = nil
      redirect_to refill_path
    end

    def payment_success
      secure_code = params[:secure_code]

      if session[:ym][:secure_code].to_i != secure_code.to_i
        session[:ym][:success] = false
        Subscription.find(session[:ym][:subscription]).destroy rescue nil
      else #если платеж прошел успешно
        @inc = IncomingMoney.create(:user => current_user, :data => params.to_h )
        all_subs = current_user.find_subscription([true, false], false, false)
        all_subs.update_all(active: false)
        all_subs.where(id: session[:ym][:subscription]).update_all(active: true)
        session[:ym][:success] = true
      end
      redirect_to refill_path
    end

    private

    def not_ym_successful(ym)
      err = "Ошибка работы с модулем оплаты"
      err << "status: #{(ym.status rescue nil)} error: #{ym.error}" if Rails.env.development?
      Subscription.find(session[:ym][:subscription]).destroy rescue nil
      session[:ym][:success] = false
      session[:ym][:subscription] = nil
      session[:ym][:error] = err
      redirect_to refill_path
      return
    end

    def create_subscription(params_sub)
      user = User.where(email: params_sub[:email]).last
      user.present? ? params_sub[:user_id] = user.id : params_sub[:type] = "new_user"
      (params_sub[:type_account] == "user" ? params_sub[:sum] = 1490.00 : params_sub[:sum] = 50000.00) if params[:sum].blank?
      subscription = Subscription.build(params_sub)
      subscription.save
      subscription
    end
  end
end
