require 'yandex_money/api'

module YandexMoneyHelper
  class YM
    include Rails.application.routes.url_helpers
    include ApplicationHelper

    CLIENT_ID = $ym_secrets.app_id
    SHOP_ID = $ym_secrets.shop_id
    SCID = $ym_secrets.scid

    attr_reader :successful
    attr_reader :error
    attr_reader :secure_code

    def initialize
      @current_domain = current_domain(5000)
      #Получение идентификатора экземпляра приложения на основе client_id
      @instance_id = YandexMoney::ExternalPayment.get_instance_id(CLIENT_ID)
      if @instance_id.status == "success"
        @instance_id = @instance_id.instance_id
        @ext_pay = YandexMoney::ExternalPayment.new @instance_id
        @successful = true
      else
        @successful = false
        @error = @instance_id.error
      end
    end

    # Пополнение счета: card_number: '4850780000774141'
    def recieve_payment(amount, email)
      @successful = false
      @secure_code = Random.rand(10000000..99999999)
      response = @ext_pay.request_external_payment(
        {
          pattern_id: SCID,
          scid: SCID,
          ShopID: SHOP_ID,
          Sum: amount,
          customerNumber: email,
          paymentType: 'AC'
        })
      if response.status != "success"
        @error = response.error
        return
      end

      @request_id = response.request_id
      res = @ext_pay.process_external_payment(
        {
          request_id: @request_id,
          ext_auth_success_uri: @current_domain + payment_success_path(:secure_code => @secure_code),
          ext_auth_fail_uri: @current_domain + payment_fail_path
        })
      @successful = true
      res
    rescue => e
      @successful = false
      @error = e.message
      {:status => "error", :error => e.message}
    end
  end
end