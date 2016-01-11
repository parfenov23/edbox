class IncomingMoney < ActiveRecord::Base
  serialize :data, ActiveRecord::Coders::Hstore
  belongs_to :user

  def self.create(*args)
  	binding.pry
  	hash_params = args.first
  	im = new
  	if hash_params.present?
  		im = new(hash_params)
  		im.data = hash_params[:data]
  		im.save
  	end
  	im
  end
end
