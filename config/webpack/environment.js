// ShinyCMS ~ https://shinycms.org
//
// Copyright 2009-2021 Denny de la Haye ~ https://denny.me
//
// ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

const { environment } = require( '@rails/webpacker' )

const webpack = require( 'webpack' )

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

module.exports = environment
