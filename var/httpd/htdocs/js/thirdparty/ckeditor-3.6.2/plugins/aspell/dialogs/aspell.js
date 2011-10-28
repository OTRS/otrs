
var FCKLang;
var OnSpellerControlsLoad;

CKEDITOR.dialog.add('aspell', function( editor )
{
	var number = CKEDITOR.tools.getNextNumber(),
		iframeId = 'cke_frame_' + number,
		textareaId = 'cke_data_' + number,
		interval,
		errorMsg = editor.lang.spellCheck.notAvailable;
	
	var spellHTML =
	// Input for exchanging data CK<--->spellcheck
		'<textarea name="'+textareaId+'" id="'+textareaId+
		'" style="display: none;"></textarea>' +
	// Spellcheck iframe
		'<iframe src="" style="width:485px; height:380px"' +
		' frameborder="0" name="' + iframeId + '" id="' + iframeId + '"' +
		' allowtransparency="1"></iframe>';
	
	function spellTime(dialog, errorMsg)
	{
		var i = 0;
		return function()
		{
			if (typeof window.spellChecker == 'function')
			{
				// Call from window.setInteval expected at once.
				if (typeof interval != 'undefined')
					window.clearInterval(interval);
				
				// Create spellcheck object, set options/attributes
				var oSpeller = new spellChecker(document.getElementById(textareaId));
				oSpeller.spellCheckScript = CKEDITOR.config.spellerPagesServerScript;
				//oSpeller.spellCheckScript = editor.plugins.aspell.path+'spellerpages/server-scripts/spellchecker.php';
				oSpeller.OnFinished = function (numChanges) { oSpeller_OnFinished(dialog, numChanges) };
				oSpeller.popUpUrl = editor.plugins.aspell.path+'spellerpages/spellchecker.html';
				oSpeller.popUpName = iframeId;
				oSpeller.popUpProps = null;
				
				// Place language in global variable;
				// A bit of a hack, but how does e.g. controls.html know which language to use?
				FCKLang = {};
				// spellChecker.js
				FCKLang.DlgSpellNoChanges     = CKEDITOR.lang[editor.langCode].spellCheck.noChanges;
				FCKLang.DlgSpellNoMispell     = CKEDITOR.lang[editor.langCode].spellCheck.noMispell;
				FCKLang.DlgSpellOneChange     = CKEDITOR.lang[editor.langCode].spellCheck.oneChange;
				FCKLang.DlgSpellManyChanges   = CKEDITOR.lang[editor.langCode].spellCheck.manyChanges;
				// controls.html
				FCKLang.DlgSpellNotInDic      = CKEDITOR.lang[editor.langCode].spellCheck.notInDic;
				FCKLang.DlgSpellChangeTo      = CKEDITOR.lang[editor.langCode].spellCheck.changeTo;
				FCKLang.DlgSpellBtnIgnore     = CKEDITOR.lang[editor.langCode].spellCheck.btnIgnore;
				FCKLang.DlgSpellBtnIgnoreAll  = CKEDITOR.lang[editor.langCode].spellCheck.btnIgnoreAll;
				FCKLang.DlgSpellBtnReplace    = CKEDITOR.lang[editor.langCode].spellCheck.btnReplace;
				FCKLang.DlgSpellBtnReplaceAll = CKEDITOR.lang[editor.langCode].spellCheck.btnReplaceAll;
				FCKLang.DlgSpellBtnUndo       = CKEDITOR.lang[editor.langCode].spellCheck.btnUndo;
				// controlWindow.js
				FCKLang.DlgSpellNoSuggestions = CKEDITOR.lang[editor.langCode].spellCheck.noSuggestions;
				// spellchecker.html
				FCKLang.DlgSpellProgress      = CKEDITOR.lang[editor.langCode].spellCheck.progress;
				// End language
				
				// Start spellcheck!
				oSpeller.openChecker();
			}
			else if (i++ == 180) // Timeout: 180 * 250ms = 45s.
			{
				alert(errorMsg);
				dialog.hide();
			}
		};
	}
	
	function oSpeller_OnFinished(dialog, numberOCorrections)
	{
		if (numberOCorrections > 0)
		{
			editor.focus();
			editor.fire('saveSnapshot'); // Best way I could find to trigger undo steps.
			dialog.getParentEditor().setData(document.getElementById(textareaId).value);
			editor.fire('saveSnapshot'); // But there's a blank one between!
		}
		dialog.hide();
	}
	
	// Fx and IE don't see the same sizes, it seems. That or Fx is allowing everything to grow.
	var minW = 485;
	var minH = 380;
	if (document.all)
	{
		minW = 510;
		minH = 405;
	}
	
	return {
		title: editor.lang.spellCheck.title,
		minWidth: minW,
		minHeight: minH,
		buttons: [ CKEDITOR.dialog.cancelButton ],
		onShow: function()
		{
			// Put spellcheck input and iframe in the dialog content
			var contentArea = this.getContentElement('general', 'content').getElement();
			contentArea.setHtml(spellHTML);
			
			// Define spellcheck init function
			OnSpellerControlsLoad = function (controlsWindow)
			{
				// Translate the dialog box texts
				var spans  = controlsWindow.document.getElementsByTagName('span');
				var inputs = controlsWindow.document.getElementsByTagName('input');
				var i, attr;
				
				for (i=0; i < spans.length; i++)
				{
					attr = spans[i].getAttribute && spans[i].getAttribute('fckLang');
					if (attr)
						spans[i].innerHTML = FCKLang[attr];
				}
				for (i=0; i < inputs.length; i++)
				{
					attr = inputs[i].getAttribute && inputs[i].getAttribute('fckLang');
					if (attr)
						inputs[i].value = FCKLang[attr];
				}
			}
			
			// Add spellcheck script to head
			CKEDITOR.document.getHead().append(CKEDITOR.document.createElement('script', {
				attributes: {
					type: 'text/javascript',
					src: editor.plugins.aspell.path+'spellerpages/spellChecker.js'
			}}));
			
			// Get the data to be checked.
			var sData = editor.getData();
			//CKEDITOR.document.getById(textareaId).setValue(sData); <-- doesn't work for some reason
			document.getElementById(textareaId).value = sData;
			
			// Wait for spellcheck script to load, then execute
			interval = window.setInterval(spellTime(this, errorMsg), 250);
		},
		onHide: function()
		{
			window.ooo = undefined;
			window.int_framsetLoaded = undefined;
			window.framesetLoaded = undefined;
			window.is_window_opened = false;
			
			OnSpellerControlsLoad = null;
			FCKLang = null;
		},
		contents: [
			{
				id: 'general',
				label: editor.lang.spellCheck.title,
				padding: 0,
				elements: [
					{
						type: 'html',
						id: 'content',
						style: 'width:485;height:380px',
						html: '<div></div>'
					}
				]
			}
		]
	};
});
