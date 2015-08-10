AccountType.find_or_create_by(
  name: 'individual_free',
  title: 'персональный неоплаченный'
)
AccountType.find_or_create_by(
  name: 'individual_paid',
  title: 'персональный оплаченный'
)
AccountType.find_or_create_by(
  name: 'corporate_free',
  title: 'корпоративный неоплаченный'
)
AccountType.find_or_create_by(
  name: 'corporate_paid',
  title: 'корпоративный оплаченный'
)