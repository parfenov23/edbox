class AddWebinarIdToLigamentLead < ActiveRecord::Migration
  def change
    add_column :ligament_leads, :webinar_id, :integer
  end
end
