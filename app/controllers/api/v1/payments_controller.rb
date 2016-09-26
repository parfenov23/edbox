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
          resp = {json: {response: response_params, type: '3ds'}, status: 422}
        else
          resp = {json: {response: response, type: 'error'}, status: 422}
        end
      end
      render resp
    end

    def order_bill
      ['adconsult@mail.amocrm.ru', 'roman.pivovarov@gmail.com', 'bataline@gmail.com', 'corporateonline@robot.zapier.com'].each do |email|
        HomeMailer.order_bill(email, params, current_user).deliver
      end
      render json: {success: true}
    end

    def purchase
      subscription = create_subscription(params)
      amount = params[:sum]
      account = current_user.accounts.first
      current_user.update({social: current_user.social.merge({phone: params[:phone]})})
      result = false
      if account.present?
        options = {
          AccountId: current_user.email,
          Currency: $cloud_payments.currency,
          Description: "Оплата подписки"
        }
        response = $cloud_payments.gateway.purchase(account.token, amount, options, false)
        if response.success?
          current_user.incoming_moneys.create(data: response.params)
          current_user.sub_active(subscription)
          result = true
        end
      else
        subscription.destroy
      end
      render json: {success: result}, status: (result ? 200 : 422)
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
        resp = {message: response.message}
      end
      @response = {response: resp, success: response.success?}
      render html: "<script> var resp = #{@response.to_json.html_safe};parent.window.showMessage(resp);</script>".html_safe
    end

    def find_coupon
      render json: (BillingCoupon.where(title: params[:coupon]).last.to_json rescue {})
    end

    private

    def success_transaction(result)
      current_user.accounts.destroy_all
      current_user.accounts.create(parametrize(result))
      current_user.incoming_moneys.create(data: result)
      {json: {response: result, type: 'success'}}
    end

    def parametrize(rp)
      {token: rp["Token"], card_type: rp["CardType"],
       card_first_six: rp["CardFirstSix"],
       card_last_four: rp["CardLastFour"],
       issuer_bank_country: rp["IssuerBankCountry"]}
    end

    def create_subscription(params_sub)
      user = User.where(email: params_sub[:email]).last
      user.present? ? params_sub[:user_id] = user.id : params_sub[:type] = "new_user"
      subscription = Subscription.build(params_sub)
      #subscription.active = true
      subscription.save
      subscription
    end
  end
end