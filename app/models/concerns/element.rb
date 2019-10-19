# Common behaviour that all element models might want to use/offer
# (PageTemplateElement, PageElement, SharedElement, ProductElement, etc)
module Element
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true
    # TODO: validates :name, format: generally slug-esque
  end

  class_methods do
    def content_types
      [
        I18n.t( 'short_text' ),
        I18n.t( 'long_text'  ),
        I18n.t( 'filename'   ),
        I18n.t( 'html'       )
      ]
    end
  end
end
