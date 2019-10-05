# Model for page templates
class PageTemplate < ApplicationRecord
  validates :name,     presence: true
  validates :filename, presence: true

  has_many :pages, foreign_key: 'template_id', inverse_of: 'template',
                   dependent: :delete_all

  # Instance methods

  def file_exists?
    File.exist?(
      Rails.root.join(
        'app', 'views', 'pages', 'templates', "#{filename}.html.erb"
      )
    )
  end
end
