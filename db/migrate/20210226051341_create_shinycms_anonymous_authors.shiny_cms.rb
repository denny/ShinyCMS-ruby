# This migration comes from shiny_cms (originally 20210226050046)
class CreateShinyCMSAnonymousAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :shinycms_anonymous_authors
  end
end
