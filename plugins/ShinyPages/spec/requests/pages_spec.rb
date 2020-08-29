# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  context 'without any pages in database' do
    describe 'GET /' do
      it "fetches the 'no content yet' page" do
        get '/'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to include 'This site does not have any content'
      end
    end
  end

  context 'with at least one top-level page defined' do
    before :each do
      @page = create :top_level_page
    end

    describe 'GET /' do
      it 'fetches the first top-level page' do
        get '/'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title @page.public_name
      end

      it 'renders an error if the template file is missing' do
        page = create :top_level_page
        # rubocop:disable Rails/SkipsModelValidations
        page.template.update_column( :filename, 'no-such-file' )
        # rubocop:enable Rails/SkipsModelValidations

        Setting.set( :default_page, to: page.slug )

        get '/'

        expect( response      ).to have_http_status :failed_dependency
        expect( response.body ).to include I18n.t( 'shiny_pages.page.template_file_missing' )
      end
    end

    describe 'GET /page-name' do
      it 'fetches the specified top-level page' do
        get "/#{@page.slug}"

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title @page.public_name
      end
    end

    describe 'GET /section-name/page-name' do
      it 'fetches the specified page from the specified section' do
        page = create :page_in_section

        get "/#{page.section.slug}/#{page.slug}"

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title page.public_name
      end
    end

    describe 'GET /section-name' do
      it 'fetches the first page from the specified section' do
        section = create :page_section
        create :page_in_section, public_name: '1st Page', section: section
        create :page_in_section, public_name: '2nd Page', section: section
        create :page_in_section, public_name: '3rd Page', section: section

        get "/#{section.slug}"

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title '1st Page'
      end

      it 'fetches the default page from the specified section if one is set' do
        section = create :page_section
        page001 = create :page_in_section, public_name: '1st Page', section: section
        page002 = create :page_in_section, public_name: '2nd Page', section: section
        page003 = create :page_in_section, public_name: '3rd Page', section: section
        page001.section.update! default_page_id: page003.id

        get "/#{page002.section.slug}"

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title '3rd Page'
      end
    end

    describe 'GET /section-name/subsection-name/page-name' do
      it 'fetches the specified page from the specified subsection' do
        p = create :page_in_subsection

        get "/#{p.section.section.slug}/#{p.section.slug}/#{p.slug}"

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title p.public_name
      end
    end

    describe 'GET /non-existent-slug' do
      it 'returns a 404 if no matching page or section is found at top-level' do
        get '/non-existent-slug'

        expect( response      ).to have_http_status :not_found
        expect( response.body ).to include 'a page that does not exist'
      end
    end

    describe 'GET /existing-section/non-existent-slug' do
      it 'returns a 404 if no matching page or sub-section is found in section' do
        page = create :page_in_section

        get "/#{page.section.slug}/non-existent-slug"

        expect( response      ).to have_http_status :not_found
        expect( response.body ).to include 'a page that does not exist'
      end
    end
  end
end
