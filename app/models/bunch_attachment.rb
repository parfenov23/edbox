class BunchAttachment < ActiveRecord::Base
  belongs_to :bunch_section
  belongs_to :attachment
end
