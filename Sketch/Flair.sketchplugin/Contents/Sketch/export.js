@import 'common.js'
@import 'ui.js'
@import 'colors.js'
@import 'textstyles.js'

flair.export = {

    getWorkingScale: function () {
		var scaleOptions = ['1x', '2x', '3x'];
		var choosenScaleResult = flair.ui.createSelectDialog('What scale are you designing in?', scaleOptions, 0);
		if (choosenScaleResult.responseCode == 1000) { // NSModalResponseOK == 1000, but constant doesn't seem to work
			return choosenScaleResult.selectedItemIndex + 1; // Convert selected index back to a 1 based value matching the scale value
		} else {
			return -1;
		}
	},

	saveStringToURL: function (string, url) {
		if (string == null || url == null) {
			flair.ui.showErrorAlert('Save failed because string or URL was null');
			return false;
		}

		var nsString = [@"" stringByAppendingString: string];
		return [nsString writeToURL: url atomically: true encoding: NSUTF8StringEncoding error: null];
	},

	colorJSONString: function (color) {
		var jsonString = 'rgba(' + color.red() + ', ' + color.green() + ', ' + color.blue() + ', ' + color.alpha() + ')';
		return jsonString;
	},

	colorSetJSONString: function (colorSets) {
		var colorSetJSON = '';

		for (colorIndex = 0; colorIndex < colorSets.length; colorIndex += 1) {
			var color = colorSets[colorIndex];

			if (color.name != null && color.normal != null) {
				var colorJSON = '';
				if (colorIndex > 0) {
					colorJSON += '\n';
				}
				colorJSON += '\t\t"' + color.name + '" : {\n';
				
				var normalColor = flair.export.colorJSONString(color.normal);
				colorJSON += '\t\t\t"normal" : "' + normalColor + '"';

				if (color.highlighted != null) {
					var highlightedColor = flair.export.colorJSONString(color.highlighted);
					colorJSON += ',\n\t\t\t"highlighted" : "' + highlightedColor + '"';
				}

				if (color.selected != null) {
					var selectedColor = flair.export.colorJSONString(color.selected);
					colorJSON += ',\n\t\t\t"selected" : "' + selectedColor + '"';
				}

				if (color.disabled != null) {
					var disabledColor = flair.export.colorJSONString(color.disabled);
					colorJSON += ',\n\t\t\t"disabled" : "' + disabledColor + '"';
				}
				
				colorJSON += '\n\t\t}';
				if (colorIndex + 1 != colorSets.length) {
					colorJSON += ',';
				}

				colorSetJSON += colorJSON;
			}
		}
		return colorSetJSON;
	},

	textStylesJSONString: function (textStyles) {
		var json = '';
		for (styleIndex = 0; styleIndex < textStyles.length; styleIndex += 1) {
			var style = textStyles[styleIndex];

			if (style.name != null && style.font != null) {
				var styleJSON = '';
				if (styleIndex > 0) {
					styleJSON += '\n';
				}
				styleJSON += '\t\t"' + style.name + '" : {\n';
				styleJSON += '\t\t\t"font" : {\n';
				styleJSON += '\t\t\t\t"size" : ' + style.font.size + ',\n';
				styleJSON += '\t\t\t\t"sizeType" : "' + style.font.sizeType + '",\n';
				if (style.font.isSystemFont) {
					styleJSON += '\t\t\t\t"systemFontWeight" : "' + style.font.systemFontWeight + '"\n';
				} else {
					styleJSON += '\t\t\t\t"fontName" : "' + style.font.fontName + '"\n';
				}
				styleJSON += '\t\t\t},\n';

				styleJSON += '\t\t\t"kerning" : ' + style.kerning + ',\n';
				styleJSON += '\t\t\t"lineSpacing" : ' + style.lineSpacing;
				if (style.textColor != null) {
					styleJSON += ',\n\t\t\t"textColor" : "' + style.textColor + '"\n';
				} else {
					styleJSON += '\n';
				}
				styleJSON += '\t\t}';

				if (styleIndex + 1 != textStyles.length) {
					styleJSON += ',';
				}

				json += styleJSON;
			}
		}
		return json;
	},

	generateJSON: function (colors, textStyles) {
		var json = "{\n";
		json += '\t"colors" : {\n';

		json += flair.export.colorSetJSONString(colors);

		json += '\n\t},\n';
		json += '\t"styles" : {\n';

		json += flair.export.textStylesJSONString(textStyles);

		json += '\n\t}\n';
		json += "}\n";
		return json;
	},

	export: function (colors, textStyles) {
		if (colors.length == 0 && textStyles.length == 0) {
			flair.ui.showErrorAlert('No colors or textStyles to export');
			return;
		}

		var sortedColors = flair.export.sort(colors);
		var sortedTextStyles = flair.export.sort(textStyles);

		var json = flair.export.generateJSON(sortedColors, sortedTextStyles);
		var url = flair.ui.showSavePanel();
		if (url != null) {
			flair.export.saveStringToURL(json, url);
		}
	},

	sort: function (stylesOrColors) {
		var sorted = stylesOrColors.sort(function(a, b) {
			return a.name.localeCompare(b.name);
		});
		return sorted;
	}
}

var exportAll = function(context) {
	flair.init(context);

	var workingScale = flair.export.getWorkingScale();
	if (workingScale > 0) {
		var colorSets = flair.colors.getColors();
		var textStyles = flair.textStyles.getTextStyles(workingScale, colorSets);
		flair.export.export(colorSets, textStyles);
	} else {
		log('User cancelled the working scale input, aborting export');
	}
};

var exportColors = function(context) {
	flair.init(context);
	var colors = flair.colors.getColors();
	var textStyles = [];
	flair.export.export(colors, textStyles);
};

var exportTextStyles = function(context) {
	flair.init(context);

	var workingScale = flair.export.getWorkingScale();
	if (workingScale > 0) {
		var colorSets = [];
		var textStyles = flair.textStyles.getTextStyles(workingScale, colorSets);
		flair.export.export(colorSets, textStyles);
	}
};
