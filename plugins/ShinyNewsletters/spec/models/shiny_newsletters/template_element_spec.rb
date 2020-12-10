# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for newsletter template element model
module ShinyNewsletters
  RSpec.describe TemplateElement, type: :model do
    it_behaves_like ShinyElement do
      let( :template ) { create :newsletter_template                             }
      let( :element  ) { create :newsletter_template_element, template: template }
    end

    it_behaves_like ShinyDemoDataProvider do
      let( :model ) { described_class }
    end
  end
end
