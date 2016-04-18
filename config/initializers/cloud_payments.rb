class CloudPayments
  def public_id
    $env_mode.prod? ? "pk_2377a9bea1c81aa78ec0932c3ac6a" : "pk_7422925e4c9acd299acd41748f643"
  end

  def api_secret
    $env_mode.prod? ? "ff962d80ad7802811cf0c071e009be02" : "426e9dd0b41d71ed8fb51f953efc1ed5"
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