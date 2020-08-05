# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CapabilityCategory, type: :model do
  describe '.name_for' do
    context 'given a model for which we store capability data' do
      it 'returns the corresponding category symbol' do
        model = create :top_level_page

        result = CapabilityCategory.name_for( model )

        expect( result ).to eq :pages
      end
    end

    context 'given a model without capability data' do
      it 'logs an error and returns nil' do
        model = create :votable_ip
        message = I18n.t( 'models.capability_category.not_found', name: 'votable_ips' )

        expect( Rails.logger ).to receive( :warn ).with( message )

        result = CapabilityCategory.name_for( model )

        expect( result ).to be_nil
      end
    end
  end
end
