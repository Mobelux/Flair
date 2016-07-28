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
		var colorPredicate = NSPredicate.predicateWithFormat("name == %@", colorName);
		var colorLayer = layers.filteredArrayUsingPredicate(colorPredicate).firstObject();
		var fillStyle = colorLayer.style().fills().firstObject();
		var color = fillStyle.colorGeneric();
		return color;
	},

	getColorFromColorGroup: function (colorGroup) {
		var groupLayers = colorGroup.layers();

		var colorNamePredicate = NSPredicate.predicateWithFormat("name CONTAINS[cd] %@", flair.colors.colorName);
		var nameTextLayer = groupLayers.filteredArrayUsingPredicate(colorNamePredicate).firstObject();

		var normalColor = flair.colors.getColorValueForNameFromLayers(flair.colors.normalColorName, groupLayers);
		var highlightedColor = flair.colors.getColorValueForNameFromLayers(flair.colors.highlightedColorName, groupLayers);
		var selectedColor = flair.colors.getColorValueForNameFromLayers(flair.colors.selectedColorName, groupLayers);
		var disabledColor = flair.colors.getColorValueForNameFromLayers(flair.colors.disabledColorName, groupLayers);

		var colorName = flair.sanitizedName(nameTextLayer.stringValue());
		return {name: colorName, normal: normalColor, highlighted: highlightedColor, selected: selectedColor, disabled: disabledColor};
	},


    getColors: function () {
    	var artboards = flair.getArtboardsForName(flair.colors.colorArtboardName);
    	var colorGroups = flair.colors.getColorGroupsFromArtboards(artboards);
    	var colors = [];

    	for (colorGroupIndex = 0; colorGroupIndex < colorGroups.length; colorGroupIndex += 1) {
    		var group = colorGroups[colorGroupIndex];
    		var color = flair.colors.getColorFromColorGroup(group);
    		colors.push(color);
    	}
    	return colors;
    }
}
