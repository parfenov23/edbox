module Api::V1
  class PaymentsController < ::ApplicationController
    def update_card
      options = {
        IpAddress: request.ip,
        AccountId: current_user.email,
        Name: params[:name],
        JsonData: {updating_card: true}.to_json,
        Currency: $cloud_payments.currency,
        Description: "Добавление карты"
      }
      response = $cloud_payments.gateway.purchase(params[:cryptogram], 1, options, true)
      if response.success?
        resp = success_transaction(response.params)
      else
        response_params = response.params
        if response_params and response_params['PaReq'].present?
          resp = { json: { response: response_params, type: '3ds' }, status: 422 }
        else
          resp = { json: { response: response, type: 'error' }, status: 422 }
        end
      end
      render resp
    end

    def purchase

    end

    def remove_card
      current_user.accounts.destroy_all
      render json: {success: true}
    end

    def post3ds
      response = $cloud_payments.gateway.check_3ds(params[:MD], params[:PaRes])
      if response.success?
        resp = success_transaction(response.params)
      else
        resp = { message: response.message }
      end
      @response = { response: resp, success: response.success? }
      render html: "<script> var resp = #{@response.to_json.html_safe};parent.window.showMessage(resp);</script>".html_safe
    end

    private

    def success_transaction(result)
      current_user.accounts.destroy_all
      current_user.accounts.create(parametrize(result))
      current_user.incoming_moneys.create(data: result)
      {json: { response: result, type: 'success' } }
    end

    def parametrize(rp)
      {token: rp["Token"], card_type: rp["CardType"],
       card_first_six: rp["CardFirstSix"],
       card_last_four: rp["CardLastFour"],
       issuer_bank_country: rp["IssuerBankCountry"]}
    end
  end
end