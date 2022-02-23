"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.listThemes = exports.applyCurrentEditorTheme = exports.applyTheme = exports.applyLanguageTheme = exports.applyDefaultTheme = exports.getWorkbenchTheme = exports.clearAllLanguageThemes = exports.removeThemeForLanguage = exports.saveThemeForLanguage = exports.setDefaultTheme = exports.getDefaultTheme = exports.getTheme = exports.getThemeConfiguration = exports.hasThemeConfiguration = void 0;
const vscode = require("vscode");
const THEMES_PARAMETER_NAME = "theme-by-language.themes";
const DEFAULT_THEME_LANGUAGE = "*";
const WORKBENCH_COLOR_THEME = "workbench.colorTheme";
function hasThemeConfiguration() {
    return vscode.workspace.getConfiguration().has(THEMES_PARAMETER_NAME);
}
exports.hasThemeConfiguration = hasThemeConfiguration;
function getThemeConfiguration() {
    return vscode.workspace.getConfiguration().get(THEMES_PARAMETER_NAME);
}
exports.getThemeConfiguration = getThemeConfiguration;
function getTheme(language) {
    const conf = getThemeConfiguration();
    return conf ? conf[language] : undefined;
}
exports.getTheme = getTheme;
function getDefaultTheme() {
    return getTheme(DEFAULT_THEME_LANGUAGE);
}
exports.getDefaultTheme = getDefaultTheme;
function setDefaultTheme(theme) {
    return saveThemeForLanguage(DEFAULT_THEME_LANGUAGE, theme);
}
exports.setDefaultTheme = setDefaultTheme;
function saveThemeForLanguage(language, theme) {
    const targetThemes = getThemeConfiguration();
    targetThemes[language] = theme;
    return vscode.workspace.getConfiguration().update(THEMES_PARAMETER_NAME, targetThemes, true);
}
exports.saveThemeForLanguage = saveThemeForLanguage;
function removeThemeForLanguage(language) {
    const targetThemes = getThemeConfiguration();
    delete (targetThemes[language]);
    return vscode.workspace.getConfiguration().update(THEMES_PARAMETER_NAME, targetThemes, true);
}
exports.removeThemeForLanguage = removeThemeForLanguage;
function clearAllLanguageThemes() {
    if (hasThemeConfiguration()) {
        const defaultTheme = getDefaultTheme();
        return vscode.workspace.getConfiguration().update(THEMES_PARAMETER_NAME, undefined, true).then(() => {
            if (defaultTheme) {
                return applyTheme(defaultTheme);
            }
        });
    }
}
exports.clearAllLanguageThemes = clearAllLanguageThemes;
function getWorkbenchTheme() {
    return vscode.workspace.getConfiguration().get(WORKBENCH_COLOR_THEME);
}
exports.getWorkbenchTheme = getWorkbenchTheme;
function applyDefaultTheme() {
    return applyLanguageTheme(DEFAULT_THEME_LANGUAGE);
}
exports.applyDefaultTheme = applyDefaultTheme;
function applyLanguageTheme(language) {
    let theme = getTheme(language) || getDefaultTheme();
    if (theme) {
        return applyTheme(theme);
    }
}
exports.applyLanguageTheme = applyLanguageTheme;
function applyTheme(theme) {
    if (theme !== getWorkbenchTheme()) {
        const hasWorkspace = vscode.workspace.workspaceFolders !== undefined;
        const configurationTarget = hasWorkspace ? vscode.ConfigurationTarget.Workspace : vscode.ConfigurationTarget.Global;
        return vscode.workspace.getConfiguration().update(WORKBENCH_COLOR_THEME, theme, configurationTarget);
    }
}
exports.applyTheme = applyTheme;
function applyCurrentEditorTheme() {
    const editor = vscode.window.activeTextEditor;
    if (editor) {
        return applyLanguageTheme(editor.document.languageId);
    }
    else {
        return applyDefaultTheme();
    }
}
exports.applyCurrentEditorTheme = applyCurrentEditorTheme;
function listThemes() {
    const extensions = vscode.extensions.all;
    const themeLabels = [];
    extensions.forEach(e => {
        const contributes = e.packageJSON.contributes;
        if (contributes) {
            const contributedThemes = contributes.themes;
            if (contributedThemes) {
                contributedThemes.forEach((theme) => themeLabels.push(theme.id || theme.label));
            }
        }
    });
    return themeLabels.sort();
}
exports.listThemes = listThemes;
//# sourceMappingURL=configuration.js.map