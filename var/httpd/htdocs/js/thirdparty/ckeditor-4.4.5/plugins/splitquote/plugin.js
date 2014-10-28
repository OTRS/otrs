CKEDITOR.plugins.add('splitquote', {
    hidpi: true,
    icons: 'splitquote',
    init: function(editor) {

        editor.addCommand('splitQuote', {
            exec: function(editor) {
                var helper, quote, text, range;

                // is the cursor position within a quote (otrs-style)?
                quote = editor.elementPath().contains('div', false, true);
                if (quote !== null && quote.hasAttribute('type') && quote.getAttribute('type') === 'cite') {
                    // create a helper element to insetr at cursor position
                    helper = CKEDITOR.dom.element.createFromHtml('<br />');
                    editor.insertElement(helper);
                    // break quote at the position of the helper element
                    helper.breakParent(quote);
                    // create a second helper element with only a text node
                    text = CKEDITOR.dom.element.createFromHtml(' ');
                    // and insert after the first part of the quote
                    text.insertAfter(quote);
                    // now create a range and move cursor to the position of the text helper element
                    range = new CKEDITOR.dom.range(editor.document);
                    range.moveToElementEditablePosition(text, true);
                    editor.getSelection().selectRanges([range]);
                }
            }
        });

        editor.ui.addButton('SplitQuote', {
            label: Core.Config.Get('RichText.Lang.SplitQuote') || 'Split Quote',
            command: 'splitQuote',
            toolbar: 'insert'
        });

        editor.setKeystroke(CKEDITOR.CTRL + CKEDITOR.SHIFT + 13, 'splitQuote'); // CTRL+SHIFT+Return
    }
});