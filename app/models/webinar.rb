class Webinar < ActiveRecord::Base
  belongs_to :attachment
  has_many :ligament_leads, dependent: :destroy

  def transfer_to_json
    as_json
  end
end
