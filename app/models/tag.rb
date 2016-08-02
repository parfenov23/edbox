class Tag < ActiveRecord::Base
  has_many :bunch_tags, :dependent => :destroy
  belongs_to :tagtable, :polymorphic => true
  has_many :tags, :as => :tagtable, :dependent => :destroy
  default_scope { order("id ASC") }

  def transfer_to_json
    as_json
  end
end
