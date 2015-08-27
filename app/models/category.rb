class Category < ActiveRecord::Base
  has_many :bunch_categories, :dependent => :destroy
  default_scope { order("id ASC") }

  def transfer_to_json
    as_json
  end
end
