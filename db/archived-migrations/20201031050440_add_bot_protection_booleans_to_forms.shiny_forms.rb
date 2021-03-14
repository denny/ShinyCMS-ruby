# This migration comes from shiny_forms (originally 20201031050301)
class AddBotProtectionBooleansToForms < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_forms_forms, :use_recaptcha, :boolean, default: true
    add_column :shiny_forms_forms, :use_akismet,   :boolean, default: true
  end
end
