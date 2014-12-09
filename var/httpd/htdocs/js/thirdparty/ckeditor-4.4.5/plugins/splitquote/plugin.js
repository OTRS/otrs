CKEDITOR.plugins.add('splitquote', {
    hidpi: true,
    icons: 'splitquote',
    init: function(editor) {

        editor.addCommand('splitQuote', {
            exec: function(editor) {
                var helper, quote, text, range, cursorNode, cursorNodeLength, cursorNodeOffset;

                // is the cursor position within a quote (otrs-style)?
                quote = editor.elementPath().contains('div', false, true);
                if (quote !== null && quote.hasAttribute('type') && quote.getAttribute('type') === 'cite') {

                    // Special handling:
                    // If the cursor is at the end of a line, the <br> of this line is still behind
                    // the cursor. If the quote is now splitted, it splits before the <br>.
                    // We try to find out, if the cursor is at the end of a line just before a <br>
                    // and than move the cursor behind the <br>, which at the end moves the cursor
                    // to the beginning of the next line.
                    // Splitting the quote there will keep the <br> at the end of the previous line and
                    // wil not create an unnecessary empty new line after the split position.
                    // This will still not work correctly if a formatting ends at the end of line,
                    // like e.g. <div>blabla<u>test</u><br>blabla</div>

                    // get current cursor position, container node, length and offset
                    range = editor.getSelection().getRanges()[0];
                    cursorNode = range.startContainer;
                    cursorNodeLength = cursorNode.getLength();
                    cursorNodeOffset = range.startOffset;

                    // if cursor position is at the end of text node and next element is <br>
                    if (cursorNodeOffset === cursorNodeLength && cursorNode.hasNext() && cursorNode.getNext().getName() === 'br') {
                        range = editor.createRange();
                        // move cursor position behind the next element (= before the next next ;-) )
                        range.setStart(cursorNode.getNext().getNext(), 0);
                        range.setEnd(cursorNode.getNext().getNext(), 0);
                        editor.getSelection().selectRanges([range]);
                    }

                    // create a helper element to insert at cursor position
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