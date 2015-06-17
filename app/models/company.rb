class Company < ActiveRecord::Base
  has_many :users
  has_many :groups

  def self.build(params)
    company = new
    company.first_name = params[:name]
    company
  end
end
