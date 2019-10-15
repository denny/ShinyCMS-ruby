require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  before :all do
    Faker::UniqueGenerator.clear
  end

  describe 'GET /' do
    it "fetches the 'no content yet' page if there are no pages defined" do
      get '/'

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'This site does not have any content'
    end

    it 'fetches the first top-level page' do
      page = create :top_level_page

      get '/'

      expect( response      ).to have_http_status :ok
      expect( response.body ).to match %r{<h1>\s*#{page.title}\s*</h1>}
    end

    it 'renders an error if the template file is missing' do
      create :top_level_page
      page = create :top_level_page
      # rubocop:disable Rails/SkipsModelValidations
      page.template.update_column( :filename, 'no-such-file' )
      # rubocop:enable Rails/SkipsModelValidations
      create :setting, name: 'Default page', value: page.slug

      get '/'

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t( 'template_file_missing' )
    end
  end

  describe 'GET /pages' do
    it 'fetches the default page' do
      page = create :top_level_page

      get '/pages'

      expect( response      ).to have_http_status :ok
      expect( response.body ).to match %r{<h1>\s*#{page.title}\s*</h1>}
    end
  end

  describe 'GET /pages/page-name' do
    it 'fetches the specified top-level page' do
      page = create :top_level_page

      get "/pages/#{page.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to match %r{<h1>\s*#{page.title}\s*</h1>}
    end
  end

  describe 'GET /pages/section-name/page-name' do
    it 'fetches the specified page from the specified section' do
      page = create :page_in_section

      get "/pages/#{page.section.slug}/#{page.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to match %r{<h1>\s*#{page.title}\s*</h1>}
    end
  end

  describe 'GET /pages/section-name' do
    it 'fetches the first page from the specified section' do
      section = create :page_section
      create :page_in_section, title: '1st Page', section: section
      create :page_in_section, title: '2nd Page', section: section
      create :page_in_section, title: '3rd Page', section: section

      get "/pages/#{section.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to match %r{<h1>\s*1st Page\s*</h1>}
    end

    it 'fetches the default page from the specified section if one is set' do
      section = create :page_section
      page1 = create :page_in_section, title: '1st Page', section: section
      page2 = create :page_in_section, title: '2nd Page', section: section
      page3 = create :page_in_section, title: '3rd Page', section: section
      page1.section.update! default_page_id: page3.id

      get "/pages/#{page2.section.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to match %r{<h1>\s*3rd Page\s*</h1>}
    end
  end

  describe 'GET /pages/section-name/subsection-name/page-name' do
    it 'fetches the specified page from the specified subsection' do
      p = create :page_in_subsection

      get "/pages/#{p.section.section.slug}/#{p.section.slug}/#{p.slug}"

      expect( response ).to have_http_status :ok
      expect( response.body ).to match %r{<h1>\s*#{p.title}\s*</h1>}
    end
  end

  describe 'GET /pages/non-existent-slug' do
    it 'returns a 404 if no matching page or section is found at top-level' do
      create :top_level_page

      get '/pages/non-existent-slug'

      expect( response ).to have_http_status :not_found
      expect( response.body ).to include 'a page that does not exist'
    end
  end

  describe 'GET /pages/existing-section/non-existent-slug' do
    it 'returns a 404 if no matching page or sub-section is found in section' do
      page = create :page_in_section

      get "/pages/#{page.section.slug}/non-existent-slug"

      expect( response      ).to have_http_status :not_found
      expect( response.body ).to include 'a page that does not exist'
    end
  end
end
