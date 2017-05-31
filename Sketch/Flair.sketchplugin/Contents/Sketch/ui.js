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

@import 'common.js'

flair.ui = {
    createSelectDialog: function (message, items, defaultSelectedItemIndex) {
		defaultSelectedItemIndex = defaultSelectedItemIndex || 0

		var accessory = [[NSComboBox alloc] initWithFrame: NSMakeRect(0, 0, 200, 25)];
		[accessory addItemsWithObjectValues: items];
		[accessory selectItemAtIndex: defaultSelectedItemIndex];

		var alert = [[NSAlert alloc] init];
		[alert setMessageText: message];
		[alert addButtonWithTitle: 'OK'];
		[alert addButtonWithTitle: 'Cancel'];
		[alert setAccessoryView: accessory];

		var responseCode = [alert runModal];
		var selectedItemIndex = [accessory indexOfSelectedItem];

		return {responseCode: responseCode, selectedItemIndex: selectedItemIndex};
	},

	showSavePanel: function () {
		var savePanel = [NSSavePanel savePanel];
		[savePanel setTitle: 'Choose where to save your style JSON'];
		[savePanel setCanCreateDirectories: true];
		[savePanel setExtensionHidden: false];
		[savePanel setRequiredFileType: 'json'];
		[savePanel setAllowedFileTypes: ['json']];

		var buttonPressed = [savePanel runModal];
		if (buttonPressed == NSFileHandlingPanelOKButton) {
			return [savePanel URL];
		} else {
			return null;
		}
	},

	showErrorAlert: function (errorMessage) {
		var alert = [[NSAlert alloc] init];
		[alert setMessageText: errorMessage];
		[alert addButtonWithTitle: 'OK'];

		[alert runModal];
	}
}
