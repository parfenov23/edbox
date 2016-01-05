module Money
  class PurseController < MoneyController
    #Пополнение счета
    def refill
      @amount = 100
    end

    def refill_process
      amount = params[:amount]
      # Инициализация модуля Яндекс Деньги
      ym = YandexMoneyHelper::YM.new
      err = "Ошибка работы с модулем оплаты "
      if !ym.successful
        err << ym.error if Rails.env.development?
        session[:money_error] = err
        redirect_to refill_path
        return
      end
      # Прием платежа на кошелек Яндекс Денег
      res = ym.recieve_payment(amount, "#{current_user.id}: #{current_user.email}")
      #binding.pry
      if !ym.successful
        err << ym.error if Rails.env.development?
        session[:money_error] = err
        redirect_to refill_path
        return
      end
      # Требуется внешняя аутентификация пользователя
      if res.status != "ext_auth_required"
        err = "Нет запроса на внешнюю авторизацию"
        err << "status: #{res.status} error: #{res.error}" if Rails.env.development?
        session[:money_error] = err
        redirect_to refill_path
        return
      end
      # Сохраняем проверочный код платежа в сессии
      session[:ym_secure_code] = ym.secure_code
      session[:ym_amount] = amount

      # Отсылаем методом POST acs_params:
      @acs_params = res.acs_params
      @acs_uri = res.acs_uri
      # render :refill_process
    end

    def payment_fail
      session[:money_error] = "Платеж не прошел"
      redirect_to refill_path
    end

    def payment_success
      secure_code = params[:secure_code]

      if session[:ym_secure_code].to_i != secure_code.to_i
        session[:money_error] = "Не верный проверочный код платежа. Платеж не прошел"
        session[:ym_secure_code] = nil
        session[:amount] = nil
      else #если платеж прошел успешно
        @inc = IncomingMoney.create(:user => current_user, :data => params.to_h )
        session[:money_error] = nil
        session[:money_success] = "Платеж прошел"
      end
      redirect_to refill_path
    end
  end
end
