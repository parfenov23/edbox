class CloudPayments
  def public_id
    "pk_7422925e4c9acd299acd41748f643"
  end

  def api_secret
    "426e9dd0b41d71ed8fb51f953efc1ed5"
  end

  def currency
    "RUB"
  end

  def gateway
    ActiveMerchant::Billing::CloudpaymentsGateway.new(public_id: public_id, api_secret: api_secret)
  end
end

$cloud_payments = CloudPayments.new