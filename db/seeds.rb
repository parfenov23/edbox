AccountType.find_or_create_by(
  name: 'individual_free',
  title: 'Бесплатная индивидуальная подписка',
  corporate: false,
  paid: false
)
AccountType.find_or_create_by(
  name: 'individual_paid',
  title: 'Индивидуальная подписка',
  corporate: false,
  paid: true
)
AccountType.find_or_create_by(
  name: 'corporate_free',
  title: 'Бесплатная корпоративная подписка',
  corporate: true,
  paid: false
)
AccountType.find_or_create_by(
  name: 'corporate_paid',
  title: 'Корпоративная подписка',
  corporate: true,
  paid: true
)