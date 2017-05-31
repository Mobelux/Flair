//  MIT License
//
//  Copyright (c) 2017 Mobelux
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

var flair = {
    init: function (context) {
        flair.context = context;
        flair.document = context.document;
    },

    getAllArtboardsAcrossPages: function () {
	    var allArtboards = [];
	    for (var i = 0; i < flair.document.pages().count(); i++) {
	        var page = flair.document.pages().objectAtIndex(i);
	        var artboards = flair.arrayFromNSArray(page.artboards());
	        allArtboards = allArtboards.concat(artboards);
	    }
	    return allArtboards;
	},

	getArtboardsForName: function (artboardName) {
	    var predicate = NSPredicate.predicateWithFormat("name == %@", artboardName);
	    var allArtboards = flair.getAllArtboardsAcrossPages();
	    var allArtboardsNSArray = flair.nsArrayFromArray(allArtboards);
	    var matchingArtboards = allArtboardsNSArray.filteredArrayUsingPredicate(predicate);
	    return matchingArtboards
	},

    arrayFromNSArray: function (nsarray) {
        var output = [];
        // convert immutable NSArray to mutable array
        for (var i = 0; i < nsarray.count(); i++) {
            output.push(nsarray[i]);
        }
        return output;
    },

    nsArrayFromArray: function (array) {
	    var nsArray = NSArray.arrayWithArray(array);
	    return nsArray;
	},

	// converts a string into camelCase
	sanitizeName: function (name) {
		return name.replace(/[^A-Za-z0-9]/g, ' ').replace(/^\w|[A-Z]|\b\w|\s+/g, function (match, index) {
	        if (+match === 0 || match === '-' || match === '.' ) {
	            return ""; // or if (/\s+/.test(match)) for white spaces
	        }
	        return index === 0 ? match.toLowerCase() : match.toUpperCase();
	    });
	},

	approximatelyEqual: function (a, b, tolerance) {
		return Math.abs(a - b) < tolerance;
	}
}
