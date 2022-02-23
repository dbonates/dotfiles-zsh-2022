"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createSetThemeForCurrentFileLanguageCommand = void 0;
const vscode = require("vscode");
const configuration_1 = require("../configuration");
function createSetThemeForCurrentFileLanguageCommand() {
    const command = vscode.commands.registerCommand('theme-by-language.setThemeForCurrentFileLanguage', () => {
        const editor = vscode.window.activeTextEditor;
        if (editor) {
            const languageId = editor.document.languageId;
            const currentTheme = configuration_1.getWorkbenchTheme();
            vscode.window.showQuickPick(configuration_1.listThemes(), {
                canPickMany: false, placeHolder: `Select theme for language ${languageId}`, onDidSelectItem: i => {
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
                    // If no default theme is set (first run), set the default theme to the current theme
                    if (!configuration_1.getDefaultTheme()) {
                        configuration_1.setDefaultTheme(currentTheme).then(() => configuration_1.saveThemeForLanguage(languageId, theme));
                    }
                    else {
                        configuration_1.saveThemeForLanguage(languageId, theme);
                    }
                }
                else {
                    // Restore theme because previews may have changed it
                    configuration_1.applyCurrentEditorTheme();
                }
            }, () => {
                configuration_1.applyCurrentEditorTheme();
            });
        }
    });
    return command;
}
exports.createSetThemeForCurrentFileLanguageCommand = createSetThemeForCurrentFileLanguageCommand;
//# sourceMappingURL=setThemeForCurrentFileLanguage.js.map