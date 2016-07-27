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

		var response = new Object();
		response.responseCode = responseCode;
		response.selectedItemIndex = selectedItemIndex;
		return response;
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
		[alert setAccessoryView: accessory];

		[alert runModal];
	}
}
