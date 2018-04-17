CKEDITOR.plugins.add('contextmenu_linkopen', {
    init: function(editor) {

        // add context menu item to allow opening links
        editor.addCommand('openLinkCommand', {
            exec: function(editor) {
                var selection = editor.getSelection(),
                    element = selection.getStartElement();

                if (element.$ && element.$.href) {
                    // don't use the popup api here as we want
                    // to simulate a new window
                    window.open(element.$.href, '_blank');
                }
            }
        });

        editor.addMenuItem('openLinkItem', {
            icon: 'Redo',
            label: Core.Config.Get('RichText.Lang.OpenLink') || 'Open link',
            command: 'openLinkCommand',
            group: 'link'
        });

        editor.contextMenu.addListener(function(element) {
            if (element.getAscendant('a', true)) {
                return { openLinkItem: CKEDITOR.TRISTATE_OFF };
            }
        });
    }
});