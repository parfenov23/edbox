class Ogg < ActiveRecord::Base
  belongs_to :attachmentable, :polymorphic => true

  def self.build_or_create(model, params)
    find_or_create_by(params.merge({oggtable_type: model.class.to_s, oggtable_id: model.id}).to_h)
  end

  def to_html_hash
    {"img" => image, "title" => title, "description" => description}
  end

end
