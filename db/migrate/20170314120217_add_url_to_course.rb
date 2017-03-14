class AddUrlToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :redirect_url, :string
  end
end
