// Persist the expanded/collapsed state of the admin area side menu sections
function persist_menu_state() {
  // Find all of the expandable sections in the sidebar menu
  sections = document.getElementsByClassName( 'c-sidebar-nav-dropdown' );

  // Loop through them
  for ( i = 0; sections[i]; i++ ) {
    section = sections[i];

    // Attach listener to set/unset cookie to store expand/hide state
    section.addEventListener( 'click',
      function () {
        if ( section.className.indexOf( 'c-show' ) == -1 ) {
          // The menu section is being hidden; clear its cookie
          Cookies.remove( section.id );
        }
        else {
          // The menu section is being expanded; set a cookie
          Cookies.set( section.id, 'true' );
        }
    });
  }
}
