class YMsecrets
  def initialize
    @shop_id = 104413
    @scid = 37078
    @apps = {
      development: 'B33A384400106B587DF3583318CA4847DE86E53D9A3A26E41E0A9AFF9C050F4F',
      beta: 'BA59E932454127FBFC72F4B24E72B48B08B3A5E9294BF9EC399C51731EE4CE51',
      production: '37AA5FFA377D9C2FEBE3AB65450CA718FCC310272DCA9EFD87D429221A929C4E'
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