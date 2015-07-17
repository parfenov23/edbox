class Company < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_many :account_type_relations, :as => :modelable, :dependent => :destroy

  def self.build(params)
    company = new
    company.first_name = params[:name]
    company
  end

  def course_in_groups(course_id)
    ids_groups = groups.ids
    BunchCourse.where({group_id: ids_groups, course_id: course_id})
  end

  def schedule
    join_in_groups = groups.joins(bunch_courses: :bunch_sections)
    all_dates = join_in_groups.pluck(:date_complete).uniq
    arr_schedule = all_dates.map do |date|
      date_group = join_in_groups.where(bunch_sections: {date_complete: date}).uniq
      [{date: date, groups: date_group.ids}]
    end
    arr_schedule
  end

end
