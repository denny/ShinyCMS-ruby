class CreateShinyFormsForms < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_forms_forms do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description
      t.string :handler, null: false
      t.string :email_to
      t.string :filename
      t.string :redirect_to
      t.string :success_message
      t.integer :sort_order

      t.timestamps
    end
  end
end
