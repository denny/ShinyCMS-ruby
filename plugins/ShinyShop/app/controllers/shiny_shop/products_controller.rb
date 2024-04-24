# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
    # Main site controller for shop products - provided by ShinyShop plugin for ShinyCMS
    class ProductsController < ApplicationController
      include ShinyCMS::MainSiteControllerBase
  
      # before_action :check_feature_flags
  
      def index; end
  
      private
  
      # def strong_params
        # params.permit( :year, :month, :slug, :page, :count, :size, :per )
      # end
  
      # def check_feature_flags
        # enforce_feature_flags :shop
      # end
    end
  end
  