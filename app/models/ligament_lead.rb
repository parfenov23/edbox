class LigamentLead < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :webinar

  def transfer_to_json
    as_json
  end
end
