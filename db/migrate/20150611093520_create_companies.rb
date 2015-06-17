class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :first_name

      t.timestamps
    end
  end
end
