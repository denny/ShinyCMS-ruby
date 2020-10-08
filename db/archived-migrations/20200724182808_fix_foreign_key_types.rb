class FixForeignKeyTypes < ActiveRecord::Migration[6.0]
  def change
    change_column :blog_posts,   :blog_id, :bigint, required: true
    change_column :blog_posts,   :user_id, :bigint, required: true
    change_column :blogs,        :user_id, :bigint, required: true

    change_column :capabilities, :category_id, :bigint, required: true

    change_column :comments,     :parent_id, :bigint
    change_column :comments,     :user_id,   :bigint

    change_column :consents,     :purpose_id, :bigint, required: true

    change_column :insert_elements, :set_id, :bigint, required: true

    change_column :news_posts,    :user_id, :bigint, required: true

    change_column :page_elements, :page_id, :bigint, required: true

    change_column :page_sections, :default_page_id, :bigint
    change_column :page_sections, :section_id,      :bigint

    change_column :page_template_elements, :template_id, :bigint, required: true

    change_column :pages, :template_id, :bigint, required: true
    change_column :pages, :section_id,  :bigint

    change_column :setting_values, :setting_id, :bigint, required: true
    change_column :setting_values, :user_id,    :bigint

    change_column :subscriptions,  :list_id,       :bigint, required: true
    change_column :subscriptions,  :subscriber_id, :bigint, required: true

    change_column :user_capabilities, :user_id,       :bigint, required: true
    change_column :user_capabilities, :capability_id, :bigint, required: true
  end
end
