'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
const vscode = require("vscode");
const setThemeForCurrentFileLanguage_1 = require("./commands/setThemeForCurrentFileLanguage");
const setDefaultTheme_1 = require("./commands/setDefaultTheme");
const useDefaultThemeForCurrentFileLanguage_1 = require("./commands/useDefaultThemeForCurrentFileLanguage");
const clearCustomThemesForLanguage_1 = require("./commands/clearCustomThemesForLanguage");
const configuration_1 = require("./configuration");
let timeout;
function activate(context) {
    // Check active editor
    if (vscode.window.activeTextEditor) {
        configuration_1.applyCurrentEditorTheme();
    }
    // Listen for active editor changes
    const visibleEditorsDisposable = vscode.window.onDidChangeVisibleTextEditors((e) => {
        // There is only one editor visible but it is not a file => Revert to default theme
        if (e.length === 1 && !isFileEditor(e[0])) {
            applyDefaultThemeTimeout();
        }
    });
    const activeEditorDisposable = vscode.window.onDidChangeActiveTextEditor((e) => {
        if (timeout) {
            clearTimeout(timeout);
        }
        if (e) {
            if (isFileEditor(e)) {
                // Current editor is a file editor
                configuration_1.applyCurrentEditorTheme();
            }
            else {
                // There is only one editor visible but it is not a file => Revert to default theme
                if (vscode.window.visibleTextEditors.length === 1) {
                    applyDefaultThemeTimeout();
                }
            }
        }
        else {
            // No editor is visible => Revert to default theme
            if (vscode.window.visibleTextEditors.length === 0) {
                applyDefaultThemeTimeout();
            }
        }
    });
    context.subscriptions.push(setThemeForCurrentFileLanguage_1.createSetThemeForCurrentFileLanguageCommand());
    context.subscriptions.push(setDefaultTheme_1.createSetDefaultThemeCommand());
    context.subscriptions.push(useDefaultThemeForCurrentFileLanguage_1.createUseDefaultThemeForCurrentFileLanguageCommand());
    context.subscriptions.push(clearCustomThemesForLanguage_1.createClearCustomThemesForLanguageCommand());
    context.subscriptions.push(activeEditorDisposable);
    context.subscriptions.push(visibleEditorsDisposable);
}
exports.activate = activate;
function deactivate() {
}
exports.deactivate = deactivate;
function isFileEditor(e) {
    return e.document.uri.scheme !== 'output';
}
function applyDefaultThemeTimeout() {
    timeout = setTimeout(() => {
        configuration_1.applyDefaultTheme();
        timeout = undefined;
    }, 200);
}
//# sourceMappingURL=extension.js.map