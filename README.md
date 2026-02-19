# EmmyLua ♡ LÖVE ♡ Generator

[![Generate LÖVE EmmyLua API](https://github.com/yorik1984/EmmyLuaLOVEGenerator/actions/workflows/generate_love_api.yml/badge.svg)](https://github.com/yorik1984/EmmyLuaLOVEGenerator/actions/workflows/generate_love_api.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/yorik1984/EmmyLuaLOVEGenerator/blob/main/LICENSE)
[![Lua](https://img.shields.io/badge/Lua-5.1-blue.svg)](https://www.lua.org/)
[![LÖVE API](https://img.shields.io/badge/L%C3%96VE_API-11.5-EA316E.svg)](https://github.com/love2d-community/love-api?tab=readme-ov-file#l%C3%B6ve-api)

Automatic EmmyLua type annotation generator for [LÖVE 2D](https://love2d.org/) framework, compatible with [EmmyLua analyzer](https://github.com/EmmyLuaLs/emmylua-analyzer-rust).

## 📑 Table of Contents

- [🚀 Features](#-features)
- [📦 Usage](#-usage)
  - [Using Pre-generated Files from Repository](#using-pre-generated-files-from-repository)
  - [Manual API Generation](#manual-api-generation)
- [🧪 Testing](#-testing)
- [🔄 Automatic Updates](#-automatic-updates)
- [📋 What Gets Generated](#-what-gets-generated)
- [🆚 Differences from Emmy-love-api](#-differences-from-emmy-love-api)
- [🙏 Credits](#-credits)
- [📄 License](#-license)

## 🚀 Features

### Compatibility

- **EmmyLua**: modern versions (with `---@meta` support)
- **Lua**: 5.1
- **LÖVE**: 11.5

### Automatic API Generation

- **GitHub Actions Automation** - API automatically updates when changes occur in the official [love-api](https://github.com/love2d-community/love-api)
- **Ready-to-use Annotation Files** - `api/` folder contains ready-to-use files for all LÖVE modules

### Enhanced Type System

- **Type Tracking** - automatic collection and validation of all types from the API
- **Namespace Prefixes** - correct addition of `love.` prefix to API types
- **Union Type Support** - handles `type1 or type2` → `type1 | type2`
- **Type Inheritance** - supports supertypes (e.g., `love.Drawable`)
- **Table Types** - inline definitions `{field:type, ...}`

### Improved Generation

- **Proper Optional Parameters** - marked as `type?` in annotations
- **Default Value Information** - `(Defaults to <value>.)` in descriptions
- **Variant Sorting** - functions with the most arguments come first
- **Overload Annotations** - correct generation of function overloads
- **Varargs Support** - proper handling of `...` parameters
- **Parameter Expansion** - handles `param1, param2` as separate parameters

### Debug Mode

- **DEBUG Mode** - detailed statistics on collected types
- **Type Validation** - checks defined vs used types
- **Automatic Testing** - test suite to verify generation

## 📦 Usage

### Using Pre-generated Files from Repository

1. Download the `api/` folder from the repository:
   - For the **latest version**: use the [`main`](https://github.com/yorik1984/EmmyLuaLOVEGenerator/tree/main) branch
   - For a **specific version**: use the branch named with that version (e.g., [`11.5`](https://github.com/yorik1984/EmmyLuaLOVEGenerator/tree/11.5) for LÖVE 11.5)

1. Add the library path to `.emmyrc.json` or configure your LSP server similarly, as shown below:

```json
{
  "workspace": {
    "library": ["<full path to api directory>"]
  }
}
```

1. Restart or reload your IDE

### Manual API Generation

> [!WARNING]
> Generate API manually only if the LÖVE version you need is missing from the repository branches. Branch name corresponds to LÖVE version number (e.g., branch `11.5` contains API for LÖVE 11.5). The `main` branch always contains the latest API version.

1. Download [LÖVE API](https://github.com/love2d-community/love-api) for the version you need
2. Copy `modules/` and `love_api.lua` to the root of this repository
3. Run the generator:

```bash
# Basic generation (outputs to api/)
lua genEmmyAPI.lua

# Generate to custom folder
lua genEmmyAPI.lua "my_love_api"

# With debug information
lua genEmmyAPI.lua DEBUG

# With debug and custom folder
lua genEmmyAPI.lua DEBUG "my_api"

# Help
lua genEmmyAPI.lua HELP
```

1. Add the library path to `.emmyrc.json` or configure your LSP server similarly, as shown below:

```json
{
  "workspace": {
    "library": ["<full path to api directory>"]
  }
}
```

1. Restart or reload your IDE

## 🧪 Testing

The repository includes a suite of automatic tests:

```bash
lua test/run_tests.lua
```

Tests verify:

- Correct type generation
- Namespace prefix validation
- Proper handling of optional parameters
- Overload annotation generation

## 🔄 Automatic Updates

The repository is configured for automatic updates via GitHub Actions:

- On every push to `main` branch
- Can be manually triggered via `workflow_dispatch`

The workflow automatically:

1. Clones the official love-api
2. Generates EmmyLua annotations
3. Runs tests
4. Commits updates to the repository

## 📋 What Gets Generated

The generator creates files for all LÖVE modules:

```
api/
├── love.lua           # Core module
├── love.audio.lua     # Audio
├── love.graphics.lua  # Graphics
├── love.physics.lua   # Physics
├── love.filesystem.lua # File system
└── ... (all other modules)
```

Each file contains:

- `---@meta` and `---@namespace love` headers
- `---@class` type definitions with inheritance
- `---@alias` definitions for enums
- `---@param`, `---@return`, `---@overload` function annotations
- Links to official LÖVE documentation
- Region markers for convenient navigation

## 🆚 Differences from Emmy-love-api

### Architectural Improvements

- ✅ Nothing included by default - avoiding outdated API versions
- ✅ Ready files in `api/` - can be used immediately
- ✅ Automatic updates via GitHub Actions
- ✅ Works with modern EmmyLua (uses `---@meta` instead of classes)
- ✅ Namespace definitions - `love.Object` doesn't conflict with your types

### Generation Improvements

- ✅ Optional parameters properly marked (`type?`)
- ✅ Default values in descriptions
- ✅ Correct overload annotations
- ✅ Function variant sorting
- ✅ Type inheritance support (supertypes)
- ✅ Enums as `---@alias` instead of tables
- ✅ Correct newlines around region comments
- ✅ Class definitions before tables
- ✅ Enhanced type system with validation
- ✅ DEBUG mode for type analysis
- ✅ Custom output directory support

### Code Improvements

- ✅ Console output for progress tracking
- ✅ Tabs replaced with spaces
- ✅ Consistent indentation
- ✅ No warnings in generated files
- ✅ Automatic tests

## 🙏 Credits

Based on [Emmy-love-api](https://github.com/EmmyLua/Emmy-love-api).

- **[@tangzx](https://github.com/tangzx)** - original script
- **[@kindfulkirby](https://github.com/kindfulkirby)** - modifications and initial README
- **[@NyakoFox](https://github.com/NyakoFox)** - update for modern EmmyLua
- **[@yorik1984](https://github.com/yorik1984)** - enhanced type system, GitHub Actions, tests

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.

Based on [Emmy-love-api](https://github.com/EmmyLua/Emmy-love-api) which has no explicit license.
