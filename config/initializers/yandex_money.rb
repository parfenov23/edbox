class YMsecrets
  def initialize
    @shop_id = 104413
    @scid = 37078
    @apps = {
      development: 'B33A384400106B587DF3583318CA4847DE86E53D9A3A26E41E0A9AFF9C050F4F',
      beta: '',
      production: ''
    }
  end

  def app_id
    @apps[$env_mode.to_key]
  end

  def shop_id
    @shop_id
  end

  def scid
    @scid
  end

  def to_h
    {shop_id: shop_id, scid: scid, app_id: app_id}
  end
end

$ym_secrets = YMsecrets.new