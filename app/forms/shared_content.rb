# Form class for tying the shared content elements together
class SharedContent
  include ActiveModel::Model

  attr_accessor :elements
  attr_reader   :elements_attributes

  def elements_attributes=( incoming )
    incoming.each do |form_attrs|
      element_attrs = form_attrs[1]
      id = element_attrs[ :id ]
      elements.find( id ).update!( element_attrs )
    end
  end
end
