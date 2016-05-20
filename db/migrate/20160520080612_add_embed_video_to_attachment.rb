class AddEmbedVideoToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :embed_video, :text
  end
end
