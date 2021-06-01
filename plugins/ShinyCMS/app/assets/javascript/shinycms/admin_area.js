$( function() {
  $( '#sortable' ).sortable({
    handle: '.handle',
    update: function( _e, _ui ) {
      $( '#sort_order' ).val( $( this ).sortable( 'serialize' ) );
    }
  });

  $( '#live-sortable' ).sortable({
    handle: '.handle',
    update: function( _e, _ui ) {
      Rails.ajax({
        url:  $( this ).data( 'url' ),
        type: 'PUT',
        data: $( this ).sortable( 'serialize' ),
      });
    }
  });

  $( '#find_user_by_username' ).autocomplete({
    source: '/admin/users/usernames',
    minLength: 3
  });
});

function toggleShowHandles( show_handles ) {
  var handles = document.getElementsByClassName( 'handle' );
  var count = handles.length;

  for ( var i = 0; i < count; i++ ) {
    handles[i].hidden = !show_handles;
  }
}
