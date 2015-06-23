class Company < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :groups, :dependent => :destroy

  def self.build(params)
    company = new
    company.first_name = params[:name]
    company
  end
end
