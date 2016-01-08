class IncomingMoney < ActiveRecord::Base
  serialize :data, ActiveRecord::Coders::Hstore
  belongs_to :user

end
