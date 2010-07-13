/**
 * Aspell plug-in for CKeditor 3.0
 * Ported from FCKeditor 2.x by Christian Boisjoli, SilenceIT
 * Requires toolbar, aspell
 */

CKEDITOR.plugins.add('aspell', {
	init: function (editor) {
		// Create dialog-based command named "aspell"
		editor.addCommand('aspell', new CKEDITOR.dialogCommand('aspell'));
		
		// Add button to toolbar. Not sure why only that name works for me.
		editor.ui.addButton('SpellCheck', {
			label: editor.lang.spellCheck.toolbar,
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
		delete aspellCSS;
	},
	requires: ['toolbar']
});

