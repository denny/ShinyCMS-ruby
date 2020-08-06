# frozen_string_literal: true

Rails.application.routes.draw do
  mount ShinyNews::Engine => '/shiny_news'
end
