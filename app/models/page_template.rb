# frozen_string_literal: true

# Model for page templates
class PageTemplate < ApplicationRecord
  include ShinyDemoDataProvider

  # Associations

  has_many :pages, inverse_of: :template, foreign_key: :template_id,
                   dependent: :restrict_with_error

  has_many  :elements, -> { order( id: :asc ) },
            inverse_of: :template,
            foreign_key: :template_id,
            class_name: 'PageTemplateElement',
            dependent: :destroy

  accepts_nested_attributes_for :elements

  # Validations

  validates :filename, presence: true
  validates :name,     presence: true

  # Plugins

  paginates_per 20

  # Before/after actions

  after_create :add_elements

  # Instance methods

  def file_exists?
    PageTemplate.available_templates.include? filename
  end

  # Create template elements, based on the content of the template file
  def add_elements
    raise ActiveRecord::Rollback unless file_exists?

    file = "#{PageTemplate.template_dir}/#{filename}.html.erb"
    erb = File.read file
    erb.scan(
      %r{<%=\s+(sanitize|simple_format)?\(?\s*(\w+)\s*\)?\s+%>}
    ).uniq.each do |result|
      added = add_element result[0], result[1]
      raise ActiveRecord::Rollback unless added
    end
  end

  # Class methods

  def self.template_dir
    return if Theme.current.blank?

    Rails.root.join Theme.current.page_templates_path
  end

  # Get a list of available template files from the disk
  def self.available_templates
    return unless template_dir

    filenames = Dir.glob '*.html.erb', base: template_dir
    template_names = []
    filenames.each do |filename|
      template_names << filename.remove( '.html.erb' )
    end
    template_names.sort
  end

  # Add another validation here, because it uses the class method above
  validates :filename, inclusion: {
    in: PageTemplate.available_templates,
    message: I18n.t( 'models.page_template.template_file_must_exist' )
  }

  private

  def add_element( formatting, name )
    return add_image_element name   if formatting.nil? && name.include?( 'image' )
    return add_default_element name if formatting.nil?
    return add_html_element name    if formatting == 'sanitize'

    add_long_text_element name      if formatting == 'simple_format'
  end

  def add_default_element( name )
    elements.create( name: name )
  end

  def add_image_element( name )
    elements.create(
      name: name,
      element_type: I18n.t( 'admin.elements.image' )
    )
  end

  def add_html_element( name )
    elements.create(
      name: name,
      element_type: I18n.t( 'admin.elements.html' )
    )
  end

  def add_long_text_element( name )
    elements.create(
      name: name,
      element_type: I18n.t( 'admin.elements.long_text' )
    )
  end
end
