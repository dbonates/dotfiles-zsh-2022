"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createSetDefaultThemeCommand = void 0;
const vscode = require("vscode");
const configuration_1 = require("../configuration");
function createSetDefaultThemeCommand() {
    const command = vscode.commands.registerCommand('theme-by-language.setDefaultTheme', () => {
        vscode.window.showQuickPick(configuration_1.listThemes(), {
            canPickMany: false, placeHolder: 'Select default theme', onDidSelectItem: i => {
                let selectedTheme;
                if (typeof i === 'string') {
                    selectedTheme = i;
                }
                else {
                    selectedTheme = i.label;
                }
                configuration_1.applyTheme(selectedTheme);
            }
        }).then(theme => {
            if (theme) {
                configuration_1.setDefaultTheme(theme).then(() => configuration_1.applyCurrentEditorTheme());
            }
            else {
                configuration_1.applyCurrentEditorTheme();
            }
        }, () => {
            configuration_1.applyCurrentEditorTheme();
        });
    });
    return command;
}
exports.createSetDefaultThemeCommand = createSetDefaultThemeCommand;
//# sourceMappingURL=setDefaultTheme.js.map