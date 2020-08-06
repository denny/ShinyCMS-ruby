# frozen_string_literal: true

Rails.application.routes.draw do
  mount ShinyForms::Engine => '/shiny_forms'
end
