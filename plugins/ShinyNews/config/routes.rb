# frozen_string_literal: true

ShinyNews::Engine.routes.draw do
  scope format: false do
    get 'news',                     to: 'news#index', as: :view_news
    get 'news/:year/:month/:slug',  to: 'news#show',  as: :view_news_post,
                                    constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }
    get 'news/:year/:month',        to: 'news#month', as: :ignore5,
                                    constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }
    get 'news/:year',               to: 'news#year',  as: :ignore6,
                                    constraints: { year: %r{\d\d\d\d} }

    scope path: 'admin', module: 'admin' do
      resources :news, except: :show
    end
  end
end
