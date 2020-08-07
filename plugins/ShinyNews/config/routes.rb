# frozen_string_literal: true

ShinyNews::Engine.routes.draw do
  scope format: false do
    get 'news', to: 'news#index', as: :view_news

    get 'news/:year',               constraints: { year: %r{\d\d\d\d} },
                                    to: 'news#year', as: :view_news_year

    get 'news/:year/:month',        constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} },
                                    to: 'news#month', as: :view_news_month

    get 'news/:year/:month/:slug',  constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} },
                                    to: 'news#show', as: :view_news_post

    scope path: 'admin', module: 'admin' do
      resources :news, except: :show
    end
  end
end
