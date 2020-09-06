# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for methods on the base model
RSpec.describe ApplicationRecord, type: :model do
  context 'methods on base model' do
    describe '.models_with_demo_data' do
      it 'returns an array of model names, including blog posts and not including user data' do
        demo_models = ApplicationRecord.models_with_demo_data

        expect( demo_models ).to be_an Array

        expect( demo_models ).to     include 'ShinyBlog::Post'
        expect( demo_models ).not_to include 'User'
      end
    end
  end
end
