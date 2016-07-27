@import 'common.js'

flair.textStyles = {

    getTextStyles: function (workingScale) {
    	return [];
    },

    // Returns an array of the raw text styles
    coreTextStyles: function () {
	    var styles = flair.document.documentData().layerTextStyles().objects();
    	return styles;
    }
}
