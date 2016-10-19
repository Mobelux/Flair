@import 'common.js'

flair.textStyles = {
	// Putting this string at the beginning of your style name will cause that style to not be exported
	ignoredStylePrefix: '-',
	// Putting this string at the beginning of your style name will cause that style to use a static font size. Default styles are dynamic
	staticStylePrefix: 's ',
	// If a font's name starts with this prefix consider the font to be the system font
	systemFontDisplayNamePrefix: 'SFUIDisplay-',
    systemFontTextNamePrefix: 'SFUIText-',

	// Returns an array of Style objects, that are not set to be ignored
    getTextStyles: function (workingScale, colorSets) {
    	var rawTextStyles = flair.textStyles.rawTextStyles();
    	var convertedTextStyles = rawTextStyles.map(function(style) {
    		return flair.textStyles.convertStyle(style, workingScale, colorSets);
    	});
    	return convertedTextStyles;
    },

	// Returns an array of MSSharedStyle, for each style that we should be exporting
    rawTextStyles: function () {
		var textStyles = flair.document.documentData().layerTextStyles().objects();
    	var stylePredicate = NSPredicate.predicateWithFormat("NOT(name BEGINSWITH[cd] %@)", flair.textStyles.ignoredStylePrefix);
		var validTextStyles = textStyles.filteredArrayUsingPredicate(stylePredicate);

    	return flair.arrayFromNSArray(validTextStyles);
    },

    // Converts a MSSharedStyle into a Style JS object
    convertStyle: function (sharedStyle, workingScale, colorSets) {
    	var styleName = String(sharedStyle.name());
        if (styleName.indexOf(flair.textStyles.staticStylePrefix) == 0) {
            styleName = styleName.slice(flair.textStyles.staticStylePrefix.length);
        }
    	var sanitizedName = flair.sanitizeName(styleName);

    	var isDynamicSize = true;
    	if (styleName.indexOf(flair.textStyles.staticStylePrefix) == 0) {
    		isDynamicSize = false;
    		styleName = styleName.slice(flair.textStyles.staticStylePrefix.length);
    	}
    	var sizeType = isDynamicSize ? 'dynamic' : 'static';

    	var attributes = sharedStyle.style().textStyle().attributes();

    	var kerning = attributes.NSKern;
    	if (kerning < 0.005 || kerning == null) {
    		kerning = 0;
    	}

    	var lineHeight = attributes.NSParagraphStyle != null ? (attributes.NSParagraphStyle.maximumLineHeight() / workingScale) : 0;
    	var fontName = String(attributes.NSFont.fontName());
    	var fontSize = attributes.NSFont.pointSize() / workingScale;

    	var isSystemFont = fontName.indexOf(flair.textStyles.systemFontDisplayNamePrefix) == 0 || fontName.indexOf(flair.textStyles.systemFontTextNamePrefix) == 0;

    	var font = {size: fontSize, sizeType: sizeType, isSystemFont: isSystemFont, isDynamicSize: isDynamicSize};
    	if (isSystemFont) {
    		var lengthOfPrefix = 0;
            if (fontName.indexOf(flair.textStyles.systemFontDisplayNamePrefix) == 0) {
                lengthOfPrefix = flair.textStyles.systemFontDisplayNamePrefix.length;    
            } else if (fontName.indexOf(flair.textStyles.systemFontTextNamePrefix) == 0) {
                lengthOfPrefix = flair.textStyles.systemFontTextNamePrefix.length;
            }
            
    		font.systemFontWeight = fontName.slice(lengthOfPrefix).toLowerCase();
    	} else {
    		font.fontName = fontName;
    	}

    	var textStyle = {name: sanitizedName, font: font, lineSpacing: lineHeight, kerning: kerning};
    	// var textColorName = flair.colors.matchingColorSetName(colorSets, attributes.NSColor);
    	// if (textColorName != null) {
    	// 	textStyle.textColor = textColorName;
    	// }
    	return textStyle;
    }
}
