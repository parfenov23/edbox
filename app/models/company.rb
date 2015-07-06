class Company < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :groups, :dependent => :destroy

  def self.build(params)
    company = new
    company.first_name = params[:name]
    company
  end

  def course_in_groups(course_id)
    ids_groups = groups.ids
    BunchCourse.where({group_id: ids_groups, course_id: course_id})
  end

end
