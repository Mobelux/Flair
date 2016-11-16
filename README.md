# Flair
A way to provide style (color & text) in JSON, and have that converted to Swift

## What's the point?
There are a couple of reasons why we created Flair. We wanted a standardized way to pass color & text style between designers and developers. Many design tools will export Swift or Objective-C code for individual colors, that is hardly the whole picture. It is common that we need to think of color sets, related colors for different states of the same UI. We also wanted a single place to define not just font name/size but line spacing, and tracking/kerning. In iOS the font settings, is seperated from the line/paragraph settings and so that makes it harder to keep these related but distent values in sync. Flair unifies all of these in one place.

## Consuming app's project setup

### Flair framework
#### Cocoapods
Currently only available if you have `Mobelux-Pod-Specs` setup on your development machine.

1. Add the following to the top of your app's pod file:
`source 'git@github.com:Mobelux/Mobelux-Pod-Specs.git'`
2. Add the following to your target in your pod file:
`pod 'Flair'`
3. Do a `pod install`

#### Manual
Since Flair is Swift and Swift does not have binary compatability between versions yet, you need to include the whole `Flair.workspace` inside your app so you can have Xcode rebuild the `Flair.framework` every time you compile.

### Parser
1. Before you can add the parser to a project, you need to have something to parse. This is your [JSON style file](#Style-JSON). I recommend creating a `styles` folder in your project, place the JSON inside that. It will also be where the generated Swift code will be placed. When adding the JSON to your project sure to uncheck all targets on the file add dialog, since we don't need to include it as a resource in your app's bundle.

2. Unzip the `parser.zip` found inside the `build` folder at the root of this repo. Copy the extracted `FlairParser.bundle` into your own project's repo. In the example below I created a `utils` folder at the root of my app's repo and put the parser in there. This way everyone building your project will be running the same version of the parser and won't have to install anything.

3. Create a new run script build phase for your app's target and ensure that is happens **before** the `Compile Sources` build phase. There are two things you will need to replace. The first is `<folder>` this is the folder where the generated Swift code will be saved. If you created a `styles` folder in step 1, then you should use the path to that folder here. The second thing to replace is `<path to style.json`. `./utils/FlairParser.bundle/Contents/MacOS/FlairParser --output <folder> --json <path to style.json>`

4. Build your app. The parser will read the style JSON, and create 2 files `ColorSet+FlairParser.swift` and `Style+FlairParser.swift` in the output folder you specified.
5. Add the `ColorSet+FlairParser.swift` and `Style+FlairParser.swift` files to your project & target


## Style JSON

Flair uses a JSON file as the source of truth for the colors & styles that it creates. If you need to change any style or color values, you should edit the JSON, and **not** the generated Swift code, since the generated Swift will be regenerated and all changes lost the next time the JSON changes.

### Sketch plugin

The preferred method of creating the style JSON file is by using the Sketch plugin that can be found at `Sketch/Flair.sketchplugin`. This plugin has 3 options:

* Export everything - exports colors & text styles
* Export colors
* Export text styles

#### Exporting Colors
For color exporting to work, the plugin epects the open Sketch file to have an artboard named `Colors`. Inside that artboard there should be a group for each color set. The group names don't matter. Inside each color group there should be a text box named `Color Name`. The text content of the box is used as the `colorName` in the JSON. There should then be at 1 to 4 layers that are filled with the various color states. There should always be a layer named `Normal`. `Highlighted`, `Selected` and `Disabled` are optional. The fill color of each of these layers should be a solid color.

#### Exporting Text Styles
The plugin will export all named text styles unless the style name begins with a `- ` (dash followed by a space). If you choose to export everything, then the plugin will search all of the named colors for one who's `Normal` color exactly matches the text style's color. If an exact match is found then that text style will have it's `textColor` set in the JSON. If you use the `SF UI Display` font, that will be treated as system font of weight, otherwise the font name/weight will be exported. Character spacing, line spacing, and font size are also exported as part of the style if set.

### Style file structure

A style file should be a valid JSON dictionary, containing two keys: `colors` & `styles`. There should be at minimum 1 color or 1 style.

```
{
    "colors" : {
    	"colorName" : {
    		"normal" : "rgba(0.0, 1.1, 0.25, 1.0)",
    		"highlighted" : "rgba(0.0, 1.1, 0.25, 1.0)",
    		"selected" : "rgba(0.0, 1.1, 0.25, 1.0)",
    		"disabled" : "rgba(0.0, 1.1, 0.25, 1.0)"
    	}
    },
    
    "styles" : {
    	"styleName" : {
    		"font" : {
    			"size" : 17,
    			"fontName" : "Arial-Black",
    			"systemFontWeight" : "<regular, medium, bold, thin, black, semibold, or ultralight>",
    			"sizeType" : "<static or dynamic>"
    		},
    		"lineHeightMultiple" : 2.4,
    		"kerning" : 2.5,
    		"textColor" : "colorName"
    	}
    }
}

```

A valid color has a name and a `normal` value. `highlighted`, `selected`, and `disabled` color values are optional. The color values are in the sRGB color space of 0.0 to 1.0. However you can specify colors outside of that range and take advantage of the Display P3 color space for devices that support that.

A valid style has a name and a `font`. The `textColor` should be a color's name matching one of the color name keys in the `colors` dictionary.

A `font` has a required `sizeType` that is either `static` if the app should always use the exact `size` or `dynamic` if the `size` is the starting point, but the app should adjust it based on the user's dynamic text size accessability setting. The `size` is also required. There are 2 different ways you can define a font. You can only pick 1 of the two or undefined behavior results.

1. specify a `systemFontWeight` key with a value of: `regular`, `medium`, `bold`, `thin`, `black`, `semibold` or `ultralight`.
2. specify a `fontName` key with a value of the font's Postscript font name
