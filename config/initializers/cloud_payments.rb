class CloudPayments
  def public_id
    $env_mode.prod? ? "pk_c541b3e9299230109c9182224ec4f" : "pk_1e5ab229cac0bd1658806cb8caa0c"
  end

  def api_secret
    $env_mode.prod? ? "68baad20d3f126541bcf3eb2929b03b1" : "53bd01213e8ed0e9b09a816ccc2a0322"
  end

  def currency
    "RUB"
  end

  def gateway
    ActiveMerchant::Billing::CloudpaymentsGateway.new(public_id: public_id, api_secret: api_secret)
  end

  def default_options(u)
    {
      AccountId: u.email,
      Currency: currency,
      Description: "Оплата подписки"
    }
  end
end

$cloud_payments = CloudPayments.new