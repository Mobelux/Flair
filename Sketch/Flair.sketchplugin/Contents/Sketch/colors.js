@import 'common.js'

flair.colors = {
	colorArtboardName: "Colors",
	colorName: "Color Name",
	normalColorName: "Normal",
	highlightedColorName: "Highlighted",
	selectedColorName: "Selected",
	disabledColorName: "Disabled",

	/// Gets all the group layers in the given artboards. It doesn't 
    getColorGroupsFromArtboards: function (artboards) {
	    var colorGroups = [];

	    for (var artboardIndex = 0; artboardIndex < artboards.count(); artboardIndex += 1) {
	        var artboard = artboards[artboardIndex];
	        var layers = flair.arrayFromNSArray(artboard.layers());
	        for (var layerIndex = 0; layerIndex < layers.length; layerIndex += 1) {
	        	var layer = layers[layerIndex];
	        	if (layer.class() == MSLayerGroup.class()) {
	        		colorGroups.push(layer);
	        	}
	        }    
	    }

	    return colorGroups;
	},

	getColorValueForNameFromLayers: function (colorName, layers) {
		var colorPredicate = NSPredicate.predicateWithFormat("name ==[c] %@", colorName);
		var colorLayer = layers.filteredArrayUsingPredicate(colorPredicate).firstObject();
		if (colorLayer == null) { return null; }
		var fillStyle = colorLayer.style().fills().firstObject();
		if (fillStyle == null) { return null; }
		var color = fillStyle.colorGeneric();
		return color;
	},

	getColorFromColorGroup: function (colorGroup) {
		var groupLayers = colorGroup.layers();

		var normalColor = flair.colors.getColorValueForNameFromLayers(flair.colors.normalColorName, groupLayers);
		if (normalColor == null) { return null; }
		var highlightedColor = flair.colors.getColorValueForNameFromLayers(flair.colors.highlightedColorName, groupLayers);
		var selectedColor = flair.colors.getColorValueForNameFromLayers(flair.colors.selectedColorName, groupLayers);
		var disabledColor = flair.colors.getColorValueForNameFromLayers(flair.colors.disabledColorName, groupLayers);

		var colorName = flair.sanitizeName(colorGroup.name());
		return {name: colorName, normal: normalColor, highlighted: highlightedColor, selected: selectedColor, disabled: disabledColor};
	},


    getColors: function () {
    	var artboards = flair.getArtboardsForName(flair.colors.colorArtboardName);
    	var colorGroups = flair.colors.getColorGroupsFromArtboards(artboards);
    	var colors = [];
    	
    	for (colorGroupIndex = 0; colorGroupIndex < colorGroups.length; colorGroupIndex += 1) {
    		var group = colorGroups[colorGroupIndex];
    		var color = flair.colors.getColorFromColorGroup(group);
    		if (color != null) {
    			colors.push(color);
    		}
    	}
    	return colors;
    },

    // Finds and returns a ColorSet name that matches a NSColor
    matchingColorSetName: function (colorSets, nsColor) {
    	if (nsColor == null || colorSets == null || colorSets.length == 0) {
    		return null;
    	}
   
    	var genericRGBColorSpace = [NSColorSpace genericRGBColorSpace];
   
    	if ([nsColor colorSpace] != genericRGBColorSpace) {
    		nsColor = [nsColor colorUsingColorSpace:genericRGBColorSpace];
    	}

    	var nsColorColorSpace = [nsColor colorSpace];

    	var textRed = [nsColor redComponent];
    	var textGreen = [nsColor greenComponent];
    	var textBlue = [nsColor blueComponent];
    	var textAlpha = [nsColor alphaComponent];

    	for (colorSetIndex = 0; colorSetIndex < colorSets.length; colorSetIndex += 1) {
    		var colorSet = colorSets[colorSetIndex];
    		var normalMSColor = colorSet.normal;
    		var normalColor = [normalMSColor NSColorWithColorSpace:nsColorColorSpace];

	    	var normalRed = [normalColor redComponent];
	    	var normalGreen = [normalColor greenComponent];
	    	var normalBlue = [normalColor blueComponent];
	    	var normalAlpha = [normalColor alphaComponent];

	    	// Due to color space conversion, it's pretty common to have colors that should be considered the same but floating point precision...
	    	var tolerance = 1.0 / 255.0 / 3.0;

    		if (flair.approximatelyEqual(normalRed, textRed, tolerance) && flair.approximatelyEqual(normalGreen, textGreen, tolerance) && 
    			flair.approximatelyEqual(normalBlue, textBlue, tolerance) && flair.approximatelyEqual(normalAlpha, textAlpha, tolerance)) {
    			return colorSet.name;
    		}
    	}

    	return null;
    }
}
