# frozen_string_literal: true

# Shared test code, for testing methods and behaviour mixed-in by the ShinyPost concern
RSpec.shared_examples ShinyPost do
  describe 'methods' do
    describe '.generate_slug' do
      it 'can create a slug' do
        post.slug = nil
        expect( post.slug ).to be_blank

        post.generate_slug
        expect( post.slug ).to eq post.title.parameterize
      end
    end

    describe '.teaser' do
      it 'returns a teaser with the default number of paragraphs (3)' do
        paras = Faker::Lorem.paragraphs( number: 5 )
        text  = paras.join( "\n</p>\n<p>" )
        body  = "<p>#{text}\n</p>"
        post.update!( body: body )

        expect( post.teaser ).to     match %r{<p>.+<p>.+<p>}m
        expect( post.teaser ).not_to match %r{<p>.+<p>.+<p>.+<p>}m
      end
    end

    describe '.teaser( paragraphs: 4 )' do
      it 'returns a teaser with the specified number of paragraphs' do
        paras = Faker::Lorem.paragraphs( number: 5 )
        text  = paras.join( "\n</p>\n<p>" )
        body  = "<p>#{text}\n</p>"
        post.update!( body: body )

        expect( post.teaser( paragraphs: 4 ) ).to     match %r{<p>.+<p>.+<p>.+<p>}m
        expect( post.teaser( paragraphs: 4 ) ).not_to match %r{<p>.+<p>.+<p>.+<p>.+<p>}m
      end
    end
  end

  describe 'scopes' do
    describe '.visible' do
      it "returns posts that aren't hidden" do
        _hidden = post.class.create!(
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: 'Testing',
          user: User.first,
          show_on_site: false
        )
        future = post.class.create!(
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: 'Testing',
          user: User.first,
          posted_at: 1.day.since
        )

        expect( post.class.visible.size ).to eq 2
        expect( post.class.visible.last ).to eq future
      end
    end

    describe '.not_future_dated' do
      it "returns posts that aren't future-dated" do
        hidden = post.class.create!(
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: 'Testing',
          user: User.first,
          show_on_site: false
        )
        _future = post.class.create!(
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: 'Testing',
          user: User.first,
          posted_at: 1.day.since
        )

        expect( post.class.not_future_dated.size ).to eq 2
        expect( post.class.not_future_dated.order( :id ).last ).to eq hidden
      end
    end

    describe '.published' do
      it "returns posts that aren't hidden or future-dated" do
        _hidden = post.class.create!(
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: 'Testing',
          user: User.first,
          show_on_site: false
        )
        _future = post.class.create!(
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: 'Testing',
          user: User.first,
          posted_at: 1.day.since
        )

        expect( post.class.published.size ).to eq 1
        expect( post.class.published.last ).to eq post
      end
    end

    describe '.recent' do
      it "returns posts that aren't hidden or future-dated, in most-recent-first order" do
        older = post.class.create!(
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: 'Testing',
          user: User.first,
          posted_at: 1.day.ago
        )
        _hidden = post.class.create!(
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: 'Testing',
          user: User.first,
          show_on_site: false
        )
        _future = post.class.create!(
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: 'Testing',
          user: User.first,
          posted_at: 1.day.since
        )

        expect( post.class.recent.size ).to eq 2
        expect( post.class.recent.last ).to eq older
      end
    end
  end
end
