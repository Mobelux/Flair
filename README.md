# Flair
A way to provide style (color & text) in JSON, and have that converted to Swift


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

### Sketch plugin

### Style file structure