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
	}	
}
