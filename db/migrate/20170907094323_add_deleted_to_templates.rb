class AddDeletedToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :deleted, :boolean, default: false
  end
end