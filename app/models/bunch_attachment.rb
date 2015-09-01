class BunchAttachment < ActiveRecord::Base
  belongs_to :bunch_section
  belongs_to :attachment
  scope :all_complete, -> { where({complete: true}) }
end
