/**
 * Aspell plug-in for CKeditor 4
 * Ported from FCKeditor 2.x by Christian Boisjoli, SilenceIT
 * Extended for usage in CKEditor 4 by Marc Nilius, OTRS AG
 * Requires toolbar, aspell
 */

CKEDITOR.plugins.add('aspell', {
	init: function (editor) {
		// Create dialog-based command named "aspell"
		editor.addCommand('aspell', new CKEDITOR.dialogCommand('aspell'));

		// Add button to toolbar. Not sure why only that name works for me.
		editor.ui.addButton('SpellCheck', {
		    label: editor.lang.aspell.toolbar,
			command: 'aspell'
		});

		// Add link dialog code
		CKEDITOR.dialog.add('aspell', this.path + 'dialogs/aspell.js');

		// Add CSS
		var aspellCSS = document.createElement('link');
		aspellCSS.setAttribute( 'rel', 'stylesheet');
		aspellCSS.setAttribute('type', 'text/css');
		aspellCSS.setAttribute('href', this.path+'aspell.css');
		document.getElementsByTagName("head")[0].appendChild(aspellCSS);
	},
	icons: 'spellcheck',
	lang: ['af', 'ar', 'bg', 'bn', 'bs', 'ca', 'cs', 'cy', 'da', 'de', 'el', 'en-au', 'en-ca', 'en-gb', 'en', 'eo', 'es', 'et', 'eu', 'fi', 'fo', 'fr-ca', 'fr', 'gl', 'gu', 'he', 'hi', 'hr', 'hu', 'id', 'is', 'it', 'js', 'ka', 'km', 'ko', 'lt', 'lv', 'mk', 'mn', 'ms', 'nb', 'ml', 'no', 'pl', 'pt-br', 'pt', 'ro', 'ru', 'sk', 'sl', 'sr-latn', 'sr', 'sv', 'th', 'tr', 'ug', 'uk', 'vi', 'zh-cn', 'zh'],
	requires: ['toolbar']
});

