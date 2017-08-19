class RemoveTemplateIdAddQuotationIdFromTemplates < ActiveRecord::Migration[5.0]
  def change
      remove_reference :templates, :template, foreign_key: true
      remove_column :templates, :template_id
      add_reference :templates, :quotation, foreign_key: true
  end
end
