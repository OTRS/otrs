////////////////////////////////////////////////////
// wordWindow object
////////////////////////////////////////////////////
function wordWindow() {
	// private properties
	this._forms = [];

	// private methods
	this._getWordObject = _getWordObject;
	//this._getSpellerObject = _getSpellerObject;
	this._wordInputStr = _wordInputStr;
	this._adjustIndexes = _adjustIndexes;
	this._isWordChar = _isWordChar;
	this._lastPos = _lastPos;

	// public properties
	this.wordChar = /[a-zA-Z]/;
	this.windowType = "wordWindow";
	this.originalSpellings = new Array();
	this.suggestions = new Array();
	this.checkWordBgColor = "pink";
	this.normWordBgColor = "white";
	this.text = "";
	this.textInputs = new Array();
	this.indexes = new Array();
	//this.speller = this._getSpellerObject();

	// public methods
	this.resetForm = resetForm;
	this.totalMisspellings = totalMisspellings;
	this.totalWords = totalWords;
	this.totalPreviousWords = totalPreviousWords;
	//this.getTextObjectArray = getTextObjectArray;
	this.getTextVal = getTextVal;
	this.setFocus = setFocus;
	this.removeFocus = removeFocus;
	this.setText = setText;
	//this.getTotalWords = getTotalWords;
	this.writeBody = writeBody;
	this.printForHtml = printForHtml;
}

function resetForm() {
	if( this._forms ) {
		for( var i = 0; i < this._forms.length; i++ ) {
			this._forms[i].reset();
		}
	}
	return true;
}

function totalMisspellings() {
	var total_words = 0;
	for( var i = 0; i < this.textInputs.length; i++ ) {
		total_words += this.totalWords( i );
	}
	return total_words;
}

function totalWords( textIndex ) {
	return this.originalSpellings[textIndex].length;
}

function totalPreviousWords( textIndex, wordIndex ) {
	var total_words = 0;
	for( var i = 0; i <= textIndex; i++ ) {
		for( var j = 0; j < this.totalWords( i ); j++ ) {
			if( i == textIndex && j == wordIndex ) {
				break;
			} else {
				total_words++;
			}
		}
	}
	return total_words;
}

//function getTextObjectArray() {
//	return this._form.elements;
//}

function getTextVal( textIndex, wordIndex ) {
	var word = this._getWordObject( textIndex, wordIndex );
	if( word ) {
		return word.value;
	}
}

function setFocus( textIndex, wordIndex ) {
	var word = this._getWordObject( textIndex, wordIndex );
	if( word ) {
		if( word.type == "text" ) {
			word.focus();
			word.style.backgroundColor = this.checkWordBgColor;
		}
	}
}

function removeFocus( textIndex, wordIndex ) {
	var word = this._getWordObject( textIndex, wordIndex );
	if( word ) {
		if( word.type == "text" ) {
			word.blur();
			word.style.backgroundColor = this.normWordBgColor;
		}
	}
}

function setText( textIndex, wordIndex, newText ) {
	var word = this._getWordObject( textIndex, wordIndex );
	var beginStr;
	var endStr;
	if( word ) {
		var pos = this.indexes[textIndex][wordIndex];
		var oldText = word.value;
		// update the text given the index of the string
		beginStr = this.textInputs[textIndex].substring( 0, pos );
		endStr = this.textInputs[textIndex].substring(
			pos + oldText.length,
			this.textInputs[textIndex].length
		);
		this.textInputs[textIndex] = beginStr + newText + endStr;

		// adjust the indexes on the stack given the differences in
		// length between the new word and old word.
		var lengthDiff = newText.length - oldText.length;
		this._adjustIndexes( textIndex, wordIndex, lengthDiff );

		word.size = newText.length;
		word.value = newText;
		this.removeFocus( textIndex, wordIndex );
	}
}

/* This should be more robust for extracting words from HTML.
 * Many repercussions = project for another time; possibly
 * make it a server side project with return of everything
 * already done where only client side change (other than deleting
 * the way we're processing) would be insertion of corrections into
 * possible html markup within original spellings OR do it ALL
 * here and give the server nothing but plain text words - MWB
 * (Either way, give only plain text to spell checker)
 */
// redesigned to handle plain text search failure to find words
// returned by server
function writeBody() {
    var d = window.document;
    d.open();

    // iterate through each text input.
    for( var txtid = 0; txtid < this.textInputs.length; txtid++ ) {
        d.writeln( '<form name="textInput'+txtid+'">' );
        var wordtxt = this.textInputs[txtid];
        //this.indexes[txtid] = []; // we'll copy after this is known
        if( wordtxt ) {
            var orig = this.originalSpellings[txtid];
            if( !orig ) break;

/* Create array of word locations
 *
 * Following logic is based on four assumptions:
 * 1. Server always returns misspelled words in doc sequence
 * 2. We'll never find a misspell occurrence the server didn't find.
 *    (but handle the exception if it happens)
 * 3. Our plain text method of locating words the server found can fail
 * 4. HTML is always valid
 *
 * We end up with arrays of only those words with their locations we could find
 * using plain text search method.
 */
            var i,j,k;

            // initialize our locations working structure:
            //    serverTotal/dupFlag, totalFound/dupRef, positionArray/position
            var locations = new Array(orig.length);
            for(i=0;i<locations.length;i++) locations[i] = new Array(1,0,null);

            // now mark multiple misspell occurrences the server found
            for(i=0;i<locations.length;i++) {
                if(locations[i][0] == -1) continue; // already dup of a previous word
                    for(j=i+1;j<locations.length;j++) {
                    if(orig[j]==orig[i]) {
                            locations[i][0]++;    // add up number server found
                        locations[j][0] = -1; // mark as dup reference
                        locations[j][1] = i;  // reference to first occurrence
                    }
                    }
            }

            // find all misspell locations we can with verbatim text search for each unique
            // word and only search between tags.
            // end up with locations[i][2] == Array of all positions we found word
            var keepLooking;
            var end_idx;
            var begin_idx;
            var tagNextStart;
            for(i=0;i<locations.length;i++) {
                if(locations[i][0] == -1) continue; // dup, we've already done this word
                locations[i][2] = new Array();
                keepLooking = true;
                end_idx = 0;
                tagNextStart = wordtxt.indexOf("<"); // we only look between tags
                if(tagNextStart == -1) tagNextStart = wordtxt.length; // no tags
                do {
                    begin_idx = wordtxt.indexOf( orig[i], end_idx );
                    if(begin_idx == -1) keepLooking = false;
                    else if(tagNextStart<begin_idx) { // prevents getting a FUBAR doc
                        end_idx=wordtxt.indexOf(">",tagNextStart+1)+1; // always found if valid html
                        tagNextStart=wordtxt.indexOf("<",end_idx);
                        if(tagNextStart == -1) tagNextStart=wordtxt.length; // no more tags
                    }
                    else if( !this._isWordChar(wordtxt.charAt(begin_idx+orig[i].length)) &&
                             !this._isWordChar(wordtxt.charAt(begin_idx-1)) ) {
                        locations[i][2].push(begin_idx);
                        end_idx = begin_idx + orig[i].length + 1;
                    }
                    else end_idx = begin_idx + orig[i].length + 1;
                } while(keepLooking);
                locations[i][1] = locations[i][2].length;
                // Enforce one of our assumptions. This 'should' never happen, but if
                // we found more occurances of any word than the server found,
                // prevent mess up by getting rid of em
                if(locations[i][1]>locations[i][0]) locations[i][1]=0;
            }

            // Define all locations that have only one possibility.
            // Those for which server and we found the same number of
            // misspell occurrences for given misspelling of a word.
            for(i=0;i<locations.length;i++) {
                if(locations[i][0]==locations[i][1] && typeof(locations[i][2])=="object") {
                    locations[i][0]=1;
                    locations[i][1]=1;
                    var foundarray=locations[i][2];
                    locations[i][2]=foundarray.shift();
                    for(j=i+1;j<locations.length && foundarray.length>0;j++) {
                        if(locations[j][0] == -1 && locations[j][1]==i) {
                            locations[j][0]=1; // total 1
                            locations[j][1]=1; // found 1
                            locations[j][2]=foundarray.shift(); // the location
                        }
                    }
                }
            }

            // now reduce multiple possibilities (never a known case when using Aspell)
            //
            // Extract array of referenced words of which we've found
            // at least one that have more locations in the original
            // sequence than we could find
            var multiwords = new Array(); // each item = [ref, docPosition]
            for(i=0;i<locations.length;i++) {
                if(locations[i][0]>locations[i][1] && locations[i][1]>0) {
                    for(j=0;j<locations[i][2].length;j++) {
                        multiwords.push(new Array(i,locations[i][2][j]));
                    }
                        locations[i][0] = -1; // mark as referenced after we've extracted info
                    locations[i][1] = i;
                }
            }

            // now sort this array by sequence we found in doc (presumably like server)
            multiwords.sort(new Function("a","b","return a[1]-b[1]"));

            // Shift each location of this array to the location
            // they fit in original server sequence
            var keepLooking = true;
            var maxcheck = true;
            var minIdx = 0;
            var minLoc = 0;
            for(j=0;j<multiwords.length;j++) {
                // check each position for this word in doc order; look for
                // word location to pass minimum criteria, then look for upper
                // criteria. if it doesn't fit, go to the next occurrence
                for(keepLooking=true,i=minIdx;i<locations.length && keepLooking;i++) {
                    if(locations[i][0]==-1 && locations[i][1]==multiwords[j][0]) { // if a ref
                        if(multiwords[j][1]>minLoc) { // if beyond last word
                            for(maxcheck=true,k=i+1;k<locations.length && maxcheck;k++) {
                                if(locations[k][0] != -1 && locations[k][1]>0) {
                                    if(locations[k][2]>multiwords[j][1]) { // and if before next word
                                        locations[i][0] = 1;
                                        locations[i][1] = 1;
                                        locations[i][2] = multiwords[j][1];
                                        minIdx = i+1; // no point starting next word search before here
                                        keepLooking=false; 
                                    }
                                    maxcheck=false;
                                }
                            }
                            if(maxcheck) { //nothing is after this location
                                locations[i][0] = 1;
                                locations[i][1] = 1;
                                locations[i][2] = multiwords[j][1];
                                minIdx = i+1; 
                                keepLooking=false;
                            }
                        }
                    }
                    else if(locations[i][0] != -1) {
                        minLoc=locations[i][2];
                        minIdx=i+1; // where to start next word search
                    }
                }
            }

            // splice arrays to get rid of unfound words and their suggestions
            // (should only omit words that plain text search can't find)
            for(i=locations.length-1;i>=0;i--) { // reverse is simpler
                if(locations[i][0] == -1 || locations[i][1]==0) { // unfound ref OR none found
                    locations.splice(i,1);
                    this.originalSpellings[txtid].splice(i,1);
                    this.suggestions[txtid].splice(i,1);
                }
            }

            // finally, write out the doc and word locations
            this.indexes[txtid]= new Array(locations.length);
            d.writeln('<div class="plainText">');
            for(minLoc=0,i=0;i<locations.length;i++) {
                this.indexes[txtid][i] = locations[i][2];
                d.write(wordtxt.substring(minLoc,locations[i][2])); // before word
                d.write( this._wordInputStr(this.originalSpellings[txtid][i],txtid,i)); // the word
                minLoc = locations[i][2]+this.originalSpellings[txtid][i].length; // where to write from next
            }
            d.write(wordtxt.substring(minLoc)); // end of doc
            d.writeln('</div>');
            d.writeln('</form>');
        }
    }
    d.close();

    // set the _forms property
    this._forms = d.forms;

    // Replace all hyperlinks with spans without the href's that look like links.
    // This prevents being able to break it by navigating the wordWindow with links.
    var find = /<a(\s[^\>]*)href=\"[^\"]*\"(.*?)\<\/a\>/gi;
    var repl = '<span style="color:blue;text-decoration:underline"$1$2</span>';
    // memory leak for IE?
    //d.body.innerHTML = d.body.innerHTML.replace(find,repl);   
    var doc = d.body.innerHTML.replace(find,repl);
    d.body.innerHTML = doc;
}

// return the character index in the full text after the last word we evaluated
function _lastPos( txtid, idx ) {
	if( idx > 0 )
		return this.indexes[txtid][idx-1] + this.originalSpellings[txtid][idx-1].length;
	else
		return 0;
}

function printForHtml( n ) {
	return n ;		// by FredCK
/*
	var htmlstr = n;
	if( htmlstr.length == 1 ) {
		// do simple case statement if it's just one character
		switch ( n ) {
			case "\n":
				htmlstr = '<br/>';
				break;
			case "<":
				htmlstr = '&lt;';
				break;
			case ">":
				htmlstr = '&gt;';
				break;
		}
		return htmlstr;
	} else {
		htmlstr = htmlstr.replace( /</g, '&lt' );
		htmlstr = htmlstr.replace( />/g, '&gt' );
		htmlstr = htmlstr.replace( /\n/g, '<br/>' );
		return htmlstr;
	}
*/
}

function _isWordChar( letter ) {
	if( letter.search( this.wordChar ) == -1 ) {
		return false;
	} else {
		return true;
	}
}

function _getWordObject( textIndex, wordIndex ) {
	if( this._forms[textIndex] ) {
		if( this._forms[textIndex].elements[wordIndex] ) {
			return this._forms[textIndex].elements[wordIndex];
		}
	}
	return null;
}

function _wordInputStr( word ) {
	var str = '<input readonly ';
	str += 'class="blend" type="text" value="' + word + '" size="' + word.length + '">';
	return str;
}

function _adjustIndexes( textIndex, wordIndex, lengthDiff ) {
	for( var i = wordIndex + 1; i < this.originalSpellings[textIndex].length; i++ ) {
		this.indexes[textIndex][i] = this.indexes[textIndex][i] + lengthDiff;
	}
}
