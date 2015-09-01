class Company < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :groups, :dependent => :destroy

  def self.build(params)
    company = new
    company.first_name = params[:name]
    company
  end

  def transfer_to_json
    as_json(include: {users:{ only: [:id, :first_name, :last_name, :email]} })
  end

  def course_in_groups(course_id)
    ids_groups = groups.ids
    BunchCourse.where({group_id: ids_groups, course_id: course_id}).select(:group_id).distinct
  end

  def get_account_type
    account_type_relations.last.account_type
  end

  def update_account_type(account_type_id)
    unless account_type_id == (get_account_type.id rescue nil)
      AccountTypeRelation.new({modelable_type: "Company",
                               modelable_id: id,
                               account_type_id: account_type_id,
                               date: DateTime.now
                              }).save
    end
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

  def directors
    users.where(director: true)
  end

end
