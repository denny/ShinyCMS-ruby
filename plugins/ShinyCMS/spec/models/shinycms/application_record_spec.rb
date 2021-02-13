# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for methods on the base model
RSpec.describe ApplicationRecord, type: :model do
  describe 'methods on base model' do
    describe '.models_with_demo_data' do
      it 'returns an array of models, including blog posts and not including user data' do
        demo_models = described_class.models_with_demo_data

        expect( demo_models ).to be_an Array

        demo_model_names = demo_models.collect( &:name )

        expect( demo_model_names ).to     include 'ShinyBlog::Post'
        expect( demo_model_names ).not_to include 'User'
      end
    end
  end
end
