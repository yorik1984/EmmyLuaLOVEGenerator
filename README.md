# LuaCATS ♡ LÖVE ♡ Generator

[![Generate LÖVE LuaCATS API](https://github.com/yorik1984/love2d-definitions/actions/workflows/generate_love_api.yml/badge.svg)](https://github.com/yorik1984/love2d-definitions/actions/workflows/generate_love_api.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/yorik1984/love2d-definitions/blob/main/LICENSE)
[![Lua](https://img.shields.io/badge/Lua-5.1-blue.svg)](https://www.lua.org/)
[![LÖVE API](https://img.shields.io/badge/L%C3%96VE_API-11.5-EA316E.svg)](https://github.com/love2d-community/love-api)

Automatic LuaCATS type annotation generator for [LÖVE 2D](https://love2d.org/) framework.

<!-- TOC -->

## Table of Contents

- [🚀 Features](#-features)
  - [Compatibility](#compatibility)
  - [Automatic API Generation](#automatic-api-generation)
  - [Enhanced Type System](#enhanced-type-system)
  - [Improved Generation](#improved-generation)
- [📦 Usage](#-usage)
  - [Using Pre-generated Files from Repository](#using-pre-generated-files-from-repository)
- [🔄 Rebuilding the API](#-rebuilding-the-api)
  - [🤖 Automated Workflow](#-automated-workflow)
  - [📋 What Gets Generated](#-what-gets-generated)
  - [✋ Manual Generation (Optional)](#-manual-generation-optional)
- [🆚 Improvements](#-improvements)
  - [Architectural Improvements](#architectural-improvements)
  - [Generation Improvements](#generation-improvements)
- [📚 References & Related Projects](#-references--related-projects)
- [🙏 Credits](#-credits)
- [📄 License](#-license)

<!-- /TOC -->

## 🚀 Features

### Automatic API Generation

- **GitHub Actions Automation** - API automatically updates when changes occur in the official [love-api](https://github.com/love2d-community/love-api)
- **Ready-to-use Annotation Files** - `library/` folder contains ready-to-use files for all LÖVE modules
- **Full API Coverage**: Generates complete LÖVE API with all modules

### Enhanced Type System

- **Type Tracking** - automatic collection and validation of all types from the API
- **Smart Type Processing**
  - Handles plural forms → arrays (e.g. "tables" → `table[]`)
  - Handles unions and mixed plural/singular unions (e.g. "tables or strings" → `(table|string)[]`)
  - Replaces `and` with `or` where appropriate during processing
- **Namespace Prefixes** - correct addition of `love.` prefix to API types (builtins and descriptive types are not prefixed)
- **Type Inheritance** - supports supertypes (e.g., `love.Drawable`)

### Improved Generation

- **Best Practice Classes**
  - Generates `@class` definitions following LuaCATS conventions
  - Class names use the form: `love.module.functionName.paramName` (the generator constructs names from the API data)
  - Field formatting: ```---@field name? type Description (defaults to `value`)```
  - First field always required

- Important note about input API
  - The generator is a parser: it takes identifiers and names from the source API files (e.g., `love_api.lua` and modules) verbatim and does not modify casing or rename symbols. We assume the provided API data is valid and follows the naming conventions you expect. If the source API contains PascalCase function names, the generated class names will reflect that.

- **Proper Optional Parameters** - marked as `type?` when defaults are present
- **Variant Sorting** - functions with the most arguments come first
- **Overload Annotations** - correct generation of function overloads
- **Varargs Support** - proper handling of `...` parameters
- **Parameter Expansion** - handles `param1, param2` as separate parameters

## 📦 Usage

### Using Pre-generated Files from Repository

* Download the `library/` folder from the repository:
   - For the **latest version**: use the [`main`](https://github.com/yorik1984/love2d-definitions/tree/main) branch
   - For a **specific version**: use the branch named with that version (e.g., [`11.5`](https://github.com/yorik1984/love2d-definitions/tree/11.5) for LÖVE 11.5)

* Configure your LSP server similarly, as shown below:
```json
{
    "workspace": {
        "library": ["<full path to library directory>"]
    }
}
```

* Restart or reload your IDE

## 🔄 Rebuilding the API

### 🤖 Automated Workflow

The repository is configured for automatic updates via GitHub Actions:

- On every push to `main` branch
- Can be manually triggered via `workflow_dispatch`

The workflow automatically:

1. Clones the official love-api
2. Generates LuaCATS annotations
3. Commits updates to the repository

### 📋 What Gets Generated

The generator creates files for all LÖVE modules:

```
library/
├── love.d.lua              # Core module with global definitions and root namespace
└── love/                   # Directory containing all LÖVE submodules
    ├── audio.d.lua         # Audio module - sound playback, recording, and effects
    ├── data.d.lua          # Data module - compression, encoding, and data containers
    ├── event.d.lua         # Event module - input events and system messages
    ├── filesystem.d.lua    # Filesystem module - file I/O and directory operations
    ├── font.d.lua          # Font module - text rendering and font management
    ├── graphics.d.lua      # Graphics module - drawing, shaders, and rendering
    ├── image.d.lua         # Image module - image loading and pixel manipulation
    ├── joystick.d.lua      # Joystick module - game controller input handling
    ├── keyboard.d.lua      # Keyboard module - keyboard input and key states
    ├── math.d.lua          # Math module - vectors, matrices, and geometric operations
    ├── mouse.d.lua         # Mouse module - mouse input and cursor handling
    ├── physics.d.lua       # Physics module - Box2D physics simulation
    ├── sound.d.lua         # Sound module - audio sources and decoding
    ├── system.d.lua        # System module - OS interaction and system info
    ├── thread.d.lua        # Thread module - multithreading support
    ├── timer.d.lua         # Timer module - time measurement and delays
    ├── touch.d.lua         # Touch module - touchscreen input
    ├── video.d.lua         # Video module - video playback
    └── window.d.lua        # Window module - window management and display modes
```

Each file contains:

- `---@meta love2d` headers
- `---@class` type definitions with inheritance
- `---@alias` definitions for enums
- `---@param`, `---@return`, `---@overload` function annotations
- Links to official LÖVE documentation
- Region markers for convenient navigation

### ✋ Manual Generation (Optional)

> [!TIP]
> **You don't need to do this!** The automated workflow keeps everything up-to-date.  
> Manual generation is only for:
> - Testing custom modifications
> - Contributing to plugin development
> - Offline environments without GitHub Actions

> [!WARNING]
> Generate API manually only if the LÖVE version you need is missing from the repository branches. Branch name corresponds to LÖVE version number (e.g., branch `11.5` contains API for LÖVE 11.5). The `main` branch always contains the latest API version.

If you still want to generate files manually:
1. Download [LÖVE API](https://github.com/love2d-community/love-api) for the version you need
2. Copy `modules/` and `love_api.lua` to the root of this repository
3. Run the generator:

```bash
# Generate full API to default directory
lua genLOVE2dAPI.lua

# Generate full API to custom directory
lua genLOVE2dAPI.lua "my_luacats_api"

# Show debug info and generate to default directory
lua genLOVE2dAPI.lua DEBUG

# Show debug info and generate to custom directory
lua genLOVE2dAPI.lua DEBUG "my_luacats_api"

# Show help
lua genLOVE2dAPI.lua HELP
```

## 🆚 Improvements

### Architectural

- ✅ Nothing included by default - avoiding outdated API versions
- ✅ Ready files in `library/` - can be used immediately
- ✅ Automatic updates via GitHub Actions
- ✅ Works with modern LuaCATS (uses `---@meta`)
- ✅ Namespace definitions - `love.Object` doesn't conflict with your types

### Generation

- ✅ Optional parameters properly marked (`type?`)
- ✅ Default values in descriptions ```(defaults to `...`)```
- ✅ Correct overload annotations
- ✅ Function variant sorting
- ✅ Type inheritance support (supertypes)
- ✅ Enums as `---@alias` instead of tables
- ✅ Correct newlines around region comments
- ✅ Class definitions before functions
- ✅ Enhanced type system with validation
- ✅ DEBUG mode for type analysis
- ✅ Custom output directory support

## 📚 References & Related Projects

Expand your LÖVE development toolkit with these complementary resources:

#### [love2d-docs.nvim](https://github.com/yorik1984/love2d-docs.nvim) 📘
A comprehensive (Neo)Vim plugin that brings the entire LÖVE framework documentation into your editor with beautiful syntax highlighting.

*   **What it does:** Provides complete LÖVE API documentation via `:help`, syntax highlighting for LÖVE functions, modules, types, and callbacks, with full **Treesitter support**.
*   **✨ Key Features:**
    *   **🎨 Dual Editor Support:** Works flawlessly in both **Neovim** (with Treesitter) and **classic Vim**.
    *   **🤖 Automated Updates:** Uses GitHub Actions to stay in sync with the official love-api, just like this generator.
    *   **📖 Built-in Help:** Access documentation for any function (e.g., `:help love2d-docs-love.graphics.rectangle`) or type directly from your editor.
    *   **⚙️ Fully Customizable:** Offers flexible styling options for colors and font styles (bold, italic, etc.) for both Neovim and Vim.
    *   **📌 Version Branches:** Maintains version-specific branches (e.g., `11.5`) to match different LÖVE releases.

> **💡 Pro Tip:** Use **love2d-docs.nvim** alongside this generator for the ultimate LÖVE development setup—get beautiful inline syntax highlighting in your editor *and* intelligent IDE autocompletion from these LuaCATS annotations.

## 🙏 Credits

Based on [Emmy-love-api](https://github.com/EmmyLua/Emmy-love-api).

- [@tangzx](https://github.com/tangzx) - original script
- [@kindfulkirby](https://github.com/kindfulkirby) - modifications and initial README
- [@NyakoFox](https://github.com/NyakoFox) - update for modern LuaCATS
- [@yorik1984](https://github.com/yorik1984) - enhanced type system, GitHub Actions

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.

Based on [Emmy-love-api](https://github.com/EmmyLua/Emmy-love-api) which has no explicit license.
