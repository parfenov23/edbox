class Test < ActiveRecord::Base
  belongs_to :section
  has_many :questions, :dependent => :destroy
end
