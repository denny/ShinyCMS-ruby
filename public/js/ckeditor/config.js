/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
  // Define changes to default configuration here. For example:
  // config.language = 'fr';
  // config.uiColor = '#AADC6E';


  // ====== ( stuff cargo-culted from the ShinyCMS (Perl) config file ) ======

  // Set 800px wide instead of full page width
	config.width = 800;

	// Toolbar
	config.toolbarGroups = [
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
		{ name: 'links'  },
		{ name: 'insert' },
		{ name: 'paragraph',   groups: [ 'list', 'indent', 'blocks' ] },
		{ name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
		{ name: 'document',    groups: [ 'mode', 'document', 'doctools' ] },
		{ name: 'tools'  }
	];

	// Remove a load of buttons which we don't want by default
	config.removeButtons = 'Underline,Subscript,Superscript,RemoveFormat,'
		+ 'PasteFromWord,'
		+ 'Flash,Table,Smiley,SpecialChar,PageBreak,Iframe,'
		+ 'CreateDiv,'
		+ 'Find,Replace,SelectAll,'
		+ 'Save,NewPage,Preview,Print,Templates,'
		+ 'ShowBlocks';

	// Simplify the dialog windows.
	config.removeDialogTabs = 'image:advanced;link:advanced';

  // Removing this causes weirdness ¯\_(ツ)_/¯
  config.allowedContent = true;


  // ========== ( routes from default config, prefixed with /admin ) ==========

  /* Filebrowser routes */
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
  config.filebrowserBrowseUrl = "/admin/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
  config.filebrowserFlashBrowseUrl = "/admin/ckeditor/attachment_files";

  // The location of a script that handles file uploads in the Flash dialog.
  config.filebrowserFlashUploadUrl = "/admin/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
  config.filebrowserImageBrowseLinkUrl = "/admin/ckeditor/pictures";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
  config.filebrowserImageBrowseUrl = "/admin/ckeditor/pictures";

  // The location of a script that handles file uploads in the Image dialog.
  config.filebrowserImageUploadUrl = "/admin/ckeditor/pictures?";

  // The location of a script that handles file uploads.
  config.filebrowserUploadUrl = "/admin/ckeditor/attachment_files";


  /* ============= ( original toolbar config, for reference ) =================

  // Toolbar groups configuration.
  config.toolbar = [
    { name: 'document', groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source'] },
    { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
    // { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ], items: [ 'Find', 'Replace', '-', 'SelectAll', '-', 'Scayt' ] },
    // { name: 'forms', items: [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ] },
    { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
    { name: 'insert', items: [ 'Image', 'Flash', 'Table', 'HorizontalRule', 'SpecialChar' ] },
    { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ], items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
    '/',
    { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
    { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
    { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] }
  ];

  config.toolbar_mini = [
    { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ], items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
    { name: 'styles', items: [ 'Font', 'FontSize' ] },
    { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
    { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
    { name: 'insert', items: [ 'Image', 'Table', 'HorizontalRule', 'SpecialChar' ] }
  ];

  ========================================================================== */

};
