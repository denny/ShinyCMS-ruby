# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Admin controller for shop products - ShinyShop plugin for ShinyCMS
  class Admin::ProductsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    include ShinyCMS::Admin::WithSorting

    before_action :stash_new_page, only: %i[ new create ]
    before_action :stash_page,     only: %i[ edit update destroy ]

    helper_method :with_html_editor?

    def index
      authorize Product

      @products = Product.all
    end

    def new
      @product = Product.new
      authorize @product
    end

    def edit
      @product = Product.find( params[:id] )
      authorize @product
    end

    def with_html_editor?
      action_name == :index
    end
  end
end
