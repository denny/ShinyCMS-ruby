# Form class for tying the shared content elements together
class SharedContent
  include ActiveModel::Model

  attr_accessor :elements
  attr_accessor :elements_attributes
end
