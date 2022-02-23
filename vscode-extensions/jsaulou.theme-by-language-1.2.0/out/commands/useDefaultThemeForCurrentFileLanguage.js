"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createUseDefaultThemeForCurrentFileLanguageCommand = void 0;
const vscode = require("vscode");
const configuration_1 = require("../configuration");
function createUseDefaultThemeForCurrentFileLanguageCommand() {
    const command = vscode.commands.registerCommand('theme-by-language.useDefaultThemeForCurrentFileLanguage', () => {
        const editor = vscode.window.activeTextEditor;
        if (editor) {
            const languageId = editor.document.languageId;
            configuration_1.removeThemeForLanguage(languageId).then(() => configuration_1.applyDefaultTheme());
        }
    });
    return command;
}
exports.createUseDefaultThemeForCurrentFileLanguageCommand = createUseDefaultThemeForCurrentFileLanguageCommand;
//# sourceMappingURL=useDefaultThemeForCurrentFileLanguage.js.map