class AddSampleImageUrlToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :sample_image_url, :text
  end
end
