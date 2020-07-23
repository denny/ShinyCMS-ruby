class CreateShinyFormsForms < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_forms_forms do |t|

      t.timestamps
    end
  end
end
