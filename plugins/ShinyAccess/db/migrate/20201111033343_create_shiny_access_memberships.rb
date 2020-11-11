class CreateShinyAccessMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_access_memberships do |t|
      t.timestamp :began_at, null: false
      t.timestamp :ended_at

      t.group :references
      t.user :references

      t.timestamps
    end
  end
end
