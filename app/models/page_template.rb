# Model for page templates
class PageTemplate < ApplicationRecord
  validates :name,     presence: true
  validates :filename, presence: true

  has_many :pages, foreign_key: 'template_id',
                   inverse_of: 'template',
                   dependent: :nullify
  has_many :elements, class_name: 'PageTemplateElement',
                      foreign_key: 'template_id',
                      inverse_of: 'template',
                      dependent: :delete_all

  accepts_nested_attributes_for :elements

  # Instance methods

  # Check whether the template file is present on disk
  def file_exists?
    PageTemplate.available_templates.include? filename
  end

  # Return the full path to the template file, including filename
  def full_path
    dir = %w[ app views pages templates ]
    full_path = Rails.root.join( *dir, "#{filename}.html.erb" )
    return false unless File.file? full_path

    full_path
  end

  # To avoid triggering the MethodLength cop in the controller...
  def save_and_create_elements
    transaction do
      _unused = save
      create_elements
    end
  end

  # Create template elements, based on the content of the template file
  def create_elements
    return false unless full_path

    erb = File.read full_path
    erb.scan( %r{\@page\.elements\.[a-z][0-9a-z]*}i ).uniq.each do |elem_name|
      elem_name.remove! '@page.elements.'
      return false unless PageTemplateElement.new(
        template_id: id,
        name: elem_name
      ).save
    end
    true
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
