class Tag < ActiveRecord::Base
  has_many :bunch_tags, :dependent => :destroy
  belongs_to :tagtable, :polymorphic => true
  has_many :tags, :as => :tagtable, :dependent => :destroy

  scope :all_parents, -> { where(tagtable_type: "parent") }
  default_scope { order("id ASC") }

  def transfer_to_json
    as_json
  end

  def last?
    !tags.present?
  end

  def html_tags(curr_tag=self, course=nil)
    if !curr_tag.last?
      ul_contents = "<div class='parent_tag'><div class='title'>#{curr_tag.title}</div><ul>"
      curr_tag.tags.each do |tag|
        ul_contents << "<li #{tag.last? ? 'class="last_subtag"' : nil}>#{html_tags(tag, course)}</li>"
      end
      ul_contents << "</ul></div>"
    else
      if course.present?
        course_bunch_tags = course.bunch_tags
        class_tag = (course_bunch_tags.where(tag_id: curr_tag.id).present? ? "active" : "")
      end
      ul_contents = "<div class='tag js__contenterAddTagToCourse #{(class_tag rescue "")}' data-id=#{curr_tag.id}>#{curr_tag.title}</div>"
    end
    ul_contents
  end
end
