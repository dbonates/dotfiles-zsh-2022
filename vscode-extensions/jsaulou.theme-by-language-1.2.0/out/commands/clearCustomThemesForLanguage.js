"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createClearCustomThemesForLanguageCommand = void 0;
const vscode = require("vscode");
const configuration_1 = require("../configuration");
function createClearCustomThemesForLanguageCommand() {
    const command = vscode.commands.registerCommand('theme-by-language.clearCustomThemesForFileLanguage', () => {
        configuration_1.clearAllLanguageThemes();
    });
    return command;
}
exports.createClearCustomThemesForLanguageCommand = createClearCustomThemesForLanguageCommand;
//# sourceMappingURL=clearCustomThemesForLanguage.js.map