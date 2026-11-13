# Vue Syntax (Restricted Mode)

Syntax highlighting for `.vue` files in VS Code's [Restricted Mode](https://code.visualstudio.com/docs/editing/workspaces/workspace-trust).

[Vue (Official)](https://marketplace.visualstudio.com/items?itemName=Vue.volar) is disabled in Restricted Mode, which every newly opened folder starts in since VS Code 1.126, so `.vue` files show up as plain text until you trust the folder. This extension is Vue (Official)'s grammars and nothing else. It contains no code, so VS Code enables it in Restricted Mode.

Install it alongside Vue (Official), not instead of it. In a trusted folder both are enabled, and since they carry the same grammar, highlighting doesn't change.

Disable it wherever you disable Vue (Official). It also carries Vue (Official)'s grammar injections and language configuration for other languages, such as HTML, Pug and Markdown.

## How it's built

Every day, a workflow checks [vuejs/language-tools](https://github.com/vuejs/language-tools) for a new stable release. When there is one, it takes that release's grammars and language configuration, along with the `package.json` entries that register them, and publishes them under the same version number as Vue (Official).

## When to uninstall it

[vuejs/language-tools#6347](https://github.com/vuejs/language-tools/pull/6347) would let Vue (Official) keep its grammars in Restricted Mode itself. If that lands, you won't need this.

## License

The grammars and language configuration come from [vuejs/language-tools](https://github.com/vuejs/language-tools), © 2021-present Johnson Chu, under the MIT License. The rest of this repository is MIT too, except the icon.

The icon, `icon.svg` and `icon.png`, is the Vue logo by Evan You with a shield and padlock added in the bottom-right corner. Like the logo, it is under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/), with the extra conditions in [vuejs/art](https://github.com/vuejs/art).
