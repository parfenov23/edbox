require 'yandex_money/api'
$yandex_money = YandexMoney::Wallet.build_obtain_token_url(
  "CDFCA42FEB998A53B0194C6830E62866EABF9A1EC4FE333778B2A38B77F99BF8",
  'http://betaed.masshtab.am/',
  "account-info operation-history" # SCOPE
)