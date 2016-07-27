@import 'common.js'
@import 'ui.js'
@import 'colors.js'
@import 'textstyles.js'

flair.export = {

    getWorkingScale: function () {
		var scaleOptions = ['1x', '2x', '3x'];
		var choosenScaleResult = flair.ui.createSelectDialog('What scale are you designing in?', scaleOptions, 0);
		if (choosenScaleResult.responseCode == NSModalResponseOK) {
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

	generateJSON: function (colors, styles) {
		var json = "{";
		json += '    "colors" : {\n';

		json += '    },\n';
		json += '    "styles" : {\n';

		json += '    }\n';

		json += "\n}\n";
		return json;
	},

	export: function (colors, styles) {
		if (colors.length == 0 && styles.length == 0) {
			flair.ui.showErrorAlert('No colors or styles to export');
			return;
		}

		var sortedColors = flair.export.sort(colors);
		var sortedStyles = flair.export.sort(styles);

		var json = flair.export.generateJSON(sortedColors, sortedStyles);
		log(json);
	},

	sort: function (stylesOrColors) {
		var sorted = stylesOrColors.sort(function(a, b) {
			return a.name.localeCompare(b.name);
		});
		return sorted;
	}
}

var exportAll = function(context) {
	log("Export all");
	flair.init(context);

	var workingScale = flair.export.getWorkingScale();
	if (workingScale > 0) {
		var textStyles = flair.textStyles.getTextStyles(workingScale);
		var colors = flair.colors.getColors();
		flair.export.export(colors, styles);
	}
};

var exportColors = function(context) {
	flair.init(context);
	var colors = flair.colors.getColors();
	var textStyles = [];
	flair.export.export(colors, textStyles);
};

var exportTextStyles = function(context) {
	log("Export text styles");
	flair.init(context);

	var workingScale = flair.export.getWorkingScale();
	if (workingScale > 0) {
		var textStyles = flair.textStyles.getTextStyles(workingScale);
		var colors = [];
		flair.export.export(colors, styles);
	}
};