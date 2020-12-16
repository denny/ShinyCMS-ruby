// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs'
global.Rails = Rails;
Rails.start();

require( '@rails/activestorage' ).start()

// Currently not needed (if enabled in future, may need @rails prefix)
// require( 'turbolinks' ).start()
// require( 'channels' )  // ActionCable

require( 'jquery' )

// TODO: Try serving CSS and images via webpacker at some point?
//
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
