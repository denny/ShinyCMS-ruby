# frozen_string_literal: true

require 'rails_helper'

Rails.application.eager_load!

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
