# Model for page templates
class PageTemplate < ApplicationRecord
  validates :name,     presence: true
  validates :filename, presence: true

  has_many :pages, foreign_key: 'template_id',
                   inverse_of: 'template',
                   dependent: :restrict_with_error

  has_many :elements, -> { order( id: :asc ) },
           class_name: 'PageTemplateElement',
           foreign_key: 'template_id',
           inverse_of: 'template',
           dependent: :destroy

  accepts_nested_attributes_for :elements

  after_create :add_elements

  # Instance methods

  # Check whether the template file is present on disk
  def file_exists?
    PageTemplate.available_templates.include? filename
  end

  # Create template elements, based on the content of the template file
  def add_elements
    return unless file_exists?

    dir = %w[ app views pages templates ]
    erb = File.read( Rails.root.join( *dir, "#{filename}.html.erb" ) )
    erb.scan(
      %r{<%=\s+(sanitize|simple_format)?\(?\s*(\w+)\s*\)?\s+%>}
    ).uniq.each do |result|
      add_element result[0], result[1]
    end
  end

  # Class methods

  # Get a list of available template files from the disk
  def self.available_templates
    template_dir = Rails.root.join 'app', 'views', 'pages', 'templates'
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
    message: I18n.t( 'admin.pages.template_file_must_exist' )
  }

  private

  def add_element( formatting, name )
    if formatting.nil? && name.include?( 'image' )
      add_image_element name
    elsif formatting.nil?
      add_default_element name
    elsif formatting == 'sanitize'
      add_html_element name
    elsif formatting == 'simple_format'
      add_long_text_element name
    end
  end

  def add_default_element( name )
    elements.create!( name: name )
  end

  def add_image_element( name )
    elements.create!(
      name: name,
      content_type: I18n.t( 'admin.elements.image' )
    )
  end

  def add_html_element( name )
    elements.create!(
      name: name,
      content_type: I18n.t( 'admin.elements.html' )
    )
  end

  def add_long_text_element( name )
    elements.create!(
      name: name,
      content_type: I18n.t( 'admin.elements.long_text' )
    )
  end
end
