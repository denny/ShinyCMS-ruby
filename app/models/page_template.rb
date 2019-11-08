# Model for page templates
class PageTemplate < ApplicationRecord
  validates :name,     presence: true
  validates :filename, presence: true

  has_many :pages, foreign_key: 'template_id',
                   inverse_of: 'template',
                   dependent: :restrict_with_error

  has_many :elements, class_name: 'PageTemplateElement',
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
    dir = %w[ app views pages templates ]
    full_path = Rails.root.join( *dir, "#{filename}.html.erb" )
    return unless File.file? full_path

    erb = File.read full_path
    erb.scan( %r{<%=\s+([a-z][_0-9a-z]*)\s+%>} ).uniq.each do |result|
      elements.create!( name: result[0] )
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
    template_names
  end

  # Add another validation here, because it uses the class method above
  validates :filename, inclusion: {
    in: PageTemplate.available_templates,
    message: I18n.t( 'admin.pages.template_file_must_exist' )
  }
end
