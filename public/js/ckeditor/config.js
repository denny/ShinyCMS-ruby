/* Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	config.toolbar = [
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
		{ name: 'paragraph',   groups: [ 'list', 'blocks', 'indent', 'align' ], items: [ 'NumberedList', 'BulletedList', '-', 'Blockquote', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
		{ name: 'colors',      items:  [ 'TextColor', 'BGColor' ] },
		{ name: 'styles',      items:  [ 'FontSize' ] },
		'/',
		{ name: 'clipboard',   groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
		{ name: 'links',       items:  [ 'Link', 'Unlink', 'Anchor' ] },
		{ name: 'insert',      items:  [ 'Image', 'HorizontalRule', 'SpecialChar' ] },
		{ name: 'document',    groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source'] }
	];

	config.toolbar_mini = [
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
		{ name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ], items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
		{ name: 'colors',      items:  [ 'TextColor', 'BGColor' ] },
		{ name: 'insert',      items:  [ 'Image', 'HorizontalRule', 'SpecialChar' ] },
		{ name: 'document',    groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source'] }
	];

	// Simplify the dialog windows.
	config.removeDialogTabs = 'image:advanced;link:advanced';


	// TODO
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
  config.filebrowserBrowseUrl = "/admin/ckeditor/attachment_files";
	// The location of a script that handles file uploads.
  config.filebrowserUploadUrl = "/admin/ckeditor/attachment_files";

	// The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
  config.filebrowserImageBrowseUrl = "/admin/ckeditor/pictures";
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
  config.filebrowserImageBrowseLinkUrl = "/admin/ckeditor/pictures";
  // The location of a script that handles file uploads in the Image dialog.
  config.filebrowserImageUploadUrl = "/admin/ckeditor/pictures?";


	// ... apparently removing the next line causes weirdness to occur ¯\_(ツ)_/¯
  config.allowedContent = true;
};
