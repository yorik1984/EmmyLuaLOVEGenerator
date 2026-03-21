--[[
LuaCATS LÖVE Generator

A tool that automatically generates LuaCATS type annotations for the LÖVE 2D API.

TYPE ANNOTATION RULES:
This generator strictly follows the love_api.lua structure and applies
consistent type processing rules. The description below matches the current
implementation in this file (if you change the code, update this documentation).

1. Plural forms (tables, strings, numbers) → array type with []
   - "tables or strings" → (table|string)[]
   - "tables" → table[]

2. Singular forms (table, string, number) → simple type WITHOUT []
   - "table or string" → table|string
   - "table" → table

3. Union types use '|' separator, NEVER 'or' in generated output
   - The generator normalizes 'and' → 'or' before processing.

4. Table types with fields are represented in the output. Depending on whether
   fields have descriptions:
   - If at least one field has a non-empty description, a `---@class` with
     `---@field` lines will be generated (Best Practice style). The function
     signature uses an inline record for compactness but the class is emitted
     before the function and referenced in comments.
   - If the table has fields but none of the fields contain descriptions,
     the generator will prefer an inline record `{field: Type, ...}` in
     signatures instead of creating a `@class`.
   - If a table has no listed fields, the generator will keep the type as
     `table` (unless an `arraytype` indicates an array type).

5. Field is optional (with '?') ONLY if it has a 'default' value in the API.
   - Optionality is expressed with `?` in `---@field`/`---@param` types (e.g.
     `number?`). The textual annotation for defaults is appended as
     "(defaults to `value`.)" by the implementation (see below).
   - The helper that appends default text is appendDefaultDesc(desc, default):
     it appends "(defaults to `value`.)" when default ~= nil and DOES NOT
     automatically insert the word "optional". If you want "optional" in the
     description, add it to the source description or change the helper.

6. Determining which field/argument is considered the positional "first"
   (affects requiredness / optional marking):
   - The generator treats the first non-vararg element as the "first" positional
     parameter/field. Concretely: it scans the list left-to-right for the first
     entry with `name ~= "..."` and uses that index as the positional first.
   - If no non-vararg element exists (rare; e.g. the list contains only `"..."`),
     the generator falls back to using array position 1 as the first positional.
   - This behavior prevents a leading vararg (`"..."`) from shifting the
     positional-first semantics to a later element and causing incorrect
     optional/required marking.

7. Namespace prefix 'love.' is added to known API types (except builtins)

For detailed rules see the DETAILED TYPE PROCESSING RULES section below.

USAGE:
    lua genLOVE2dAPI.lua [OPTIONS] [OUTPUT_DIR]

OPTIONS:
    DEBUG             - Show debug information about type collection
    HELP              - Display this help message

COMMANDS:
    (no argument)     - Generate full API
                       Output directory: library/

    "path/to/dir"     - Generate full API to custom directory
                       Output directory: path/to/dir/

                       Examples:
                           lua genLOVE2dAPI.lua "my_api"
                           lua genLOVE2dAPI.lua "./custom/path/api"

    HELP              - Display this help message

                       Example:
                           lua genLOVE2dAPI.lua HELP

EXAMPLES:
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

OUTPUT:
    - Generated API is placed in specified directory (default: library/)
    - Files are organized as: <output_dir>/love/<module>.d.lua
    - Each file contains LuaCATS annotations compatible with IDEs supporting LuaCATS
]]

--[[
================================================================================
DETAILED TYPE PROCESSING RULES
================================================================================

This generator strictly binds to love_api.lua structure and applies the following
processing rules to convert API data into valid LuaCATS annotations. The items
below reflect the current implementation in this file.

--------------------------------------------------------------------------------
1. TYPE PROCESSING
--------------------------------------------------------------------------------

1.1 Plural Forms (Multiple Items)
    API: "tables"              → Output: table[]
    API: "strings"             → Output: string[]

1.2 Singular Forms (Single Item)
    API: "table"               → Output: table
    API: "string"              → Output: string
    API: "number"              → Output: number

1.3 Union Types (All Plural)
    API: "tables or strings"   → Output: (table|string)[]

1.4 Union Types (All Singular)
    API: "table or string"     → Output: table|string

1.5 Mixed Union Types
    API: "tables or string"    → Output: table[]|string

--------------------------------------------------------------------------------
2. NAMESPACE PREFIXES
--------------------------------------------------------------------------------

2.1 Builtin Types (NO prefix)
    string, number, boolean, table, function, userdata, thread, nil

2.2 Defined API Types (WITH 'love.' prefix)
    API: "Canvas"              → Output: love.Canvas
    API: "Image"               → Output: love.Image
    API: "FilterType"          → Output: love.FilterType

2.3 Types With Dot (NO changes)
    API: "love.Canvas"         → Output: love.Canvas

2.4 Table Types with Fields
    If the API entry defines `table` with fields:
      - If at least one field has a non-empty description, the generator emits a
        `---@class` with `---@field` lines before the function (Best Practice).
        The function signature still uses a compact inline record
        `{field: Type, ...}` but the comment references the generated class.
      - If fields exist but none have descriptions, the generator emits only an
        inline record `{field: Type, ...}` in signatures and does not create
        a `@class`.
      - If there are no listed fields, the generator will keep the type as
       `table` (unless an `arraytype` is present, in which case a `Type[]`
        will be emitted).

--------------------------------------------------------------------------------
3. CLASS GENERATION FOR TABLES (BEST PRACTICE STYLE)
--------------------------------------------------------------------------------

3.1 When to Generate @class
    The generator creates a `---@class` only when the table has fields and at
    least one of the fields contains a non-empty description. This provides
    useful IDE documentation without creating many empty or undocumented classes.

    If you prefer the alternative behaviour "always generate @class when table
    has fields", change the function `fieldsRequireClass` to return true
    whenever `#fields > 0`.

3.2 Class Naming Convention
    Format: module.functionName.paramName

    Note: the current implementation preserves the functionName case as it
    appears in the API when forming the class name. If you prefer to always
    lower-case the function name in class identifiers, update genClassName to
    apply string.lower(functionName).

    For parameters:  love.window.setMode.flags
    For returns:     love.window.getMode.result (single return)
                     love.window.getMode.result1, result2, ... (multiple)

    Example:
    ---Options for `love.window.setMode`.
    ---@class love.window.setMode.flags

3.3 Class Description (Best Practice)
    - Short one-line description
    - Mention function in backticks: `love.module.functionName`
    - For params: "Options for `function`."
    - For returns: "Result from `function`."

3.4 Field Documentation (Best Practice)
    Format: ---@field name? type Description (defaults to `value`)

    Rules:
    - NO '# ' separator (just space after type)
    - Use first sentence from field.description
    - Default in format: the implementation appends text in the form
      "(defaults to `value`.)" when appropriate (appendDefaultDesc(desc, default))
    - Values are shown in backticks

    Example:
    ---@field offset number? The offset of the subsection to copy, in bytes. (defaults to `0`.)
    ---@field vsync? boolean Enable vertical sync (defaults to `true`.)

3.5 Field Optionality in @class
    ✅ Field is optional (with ?) ONLY when:
       - field.default exists in API

    ❌ Field is NOT optional (without ?) when:
       - field.default does NOT exist in API

    IMPORTANT IMPLEMENTATION DETAIL:
    - The implementation determines the "first" required field by locating the
      first non-vararg entry (first index where name ~= "...") and treats that
      field as required (no '?'). If no non-vararg exists, the fallback is
      index 1. This replaces any older wording that referenced a naive
      i == 1 check.

--------------------------------------------------------------------------------
4. FUNCTION PARAMETERS
--------------------------------------------------------------------------------

4.1 Parameter Optionality
    ✅ Parameter is optional (with ?) ONLY when:
       - argument.default exists in API AND the argument is NOT the first
         positional argument (first non-vararg index).

    ❌ Parameter is NOT optional when:
       - argument.default does NOT exist in API
       - argument is the first non-vararg positional argument (treated as required).

    Note: the code computes firstNonVarargIdx (first index with name ~= "...")
    and uses that index in optionality checks. If no non-vararg exists,
    index 1 is used as fallback. The older description that relied on argIdx == 1
    without skipping varargs is superseded by this behavior.

4.2 Table Parameter with Fields (class/inline behavior)
    API: arguments = {
        {
            name = "settings",
            type = "table",
            default = "nil",
            table = { ... }  -- has fields
        }
    }
    Behaviour:
      - If `settings.table` exists and at least one field has description, the
        generator will produce a `---@class love.module.functionName.settings`
        before the function and use a compact inline record `{...}` in the
        @param signature while mentioning the class in the param comment.
      - If `settings.table` exists but fields lack descriptions, the generator
        will place an inline record `{field: Type,...}` directly in the @param
        and will NOT emit `@class`.
      - If `settings.table` is absent/empty, the generator attempts to reuse a
       `return.table` or `return.arraytype` from the same variant; reuse ONLY
        produces inline fields/class if the candidate return has real fields
        (and class only if fields have descriptions). If the candidate has no
        fields but has `arraytype`, it becomes `Type[]`. Otherwise the param
        remains `table`.

4.3 Parameter Description (Best Practice)
    - Keep it short (first sentence)
    - Add default info using appendDefaultDesc — the current implementation
      appends the default text in the form "(defaults to `value`.)" where applicable.
    - The textual word "optional" is not automatically inserted by the helper;
      optionality is conveyed via the `?` type suffix.

--------------------------------------------------------------------------------
5. FUNCTION OVERLOADS
--------------------------------------------------------------------------------

5.1 Variant Sorting
    1. By argument count (more → less)
    2. If equal, by return count (more → less)

5.2 First Variant = Main Signature
    First variant:
    ---@param x number
    ---@param y number?
    ---@return boolean name

    Other variants:
    ---@overload fun(x: number): nil

5.3 Classes in Overloads
    Overloads use the same @class names as main signature (when applicable)

--------------------------------------------------------------------------------
6. RETURN TYPES
--------------------------------------------------------------------------------

6.1 Table Return with Fields (class/inline behavior)
    API: returns = {
        {
            type = "table",
            table = {
                { name = "width", type = "number" },
                { name = "height", type = "number" }
            }
        }
    }
    Behaviour:
      - If at least one field has a description, a `---@class` is generated
        (e.g. love.module.functionName.result) and emitted before the function.
        The @return line uses an inline `{...}` but the comment references
        the generated class for field descriptions.
      - If the fields do not contain descriptions, the generator emits an inline
        record `{width: number, height: number}` in the @return and does NOT
        generate a class.
      - If `arraytype` is present and `ret.table` is empty, a `Type[]` is
        emitted (e.g. love.RecordingDevice[]).

6.2 Multiple Return Values
    API: returns = {
        { type = "number" },
        { type = "number" },
        { type = "table", table = {...} }
    }
    Output:
    ---Result from `love.module.functionName`.
    ---@class love.module.functionName.result3
    ---@field ... ...

    ---@return number
    ---@return number
    ---@return love.module.functionName.result3

--------------------------------------------------------------------------------
7. SPECIAL CASES
--------------------------------------------------------------------------------

7.1 Replace 'and' with 'or'
    API: "tables and strings"   → Process as: "tables or strings"
                                → Output: (table|string)[]

7.2 Parameters with Commas in Name
    API: arguments = {
        { name = "x, y", type = "number" }
    }
    Output (expandParameters):
    ---@param x number
    ---@param y number

7.3 Types Already with '|' (after processTypeString)
    Processing: "table|string"
              - Split by |
              - Add namespace to each part
              - Join back
    Output: "table|love.String" (if String in knownTypes)

--------------------------------------------------------------------------------
8. TYPE PROCESSING PRIORITIES
--------------------------------------------------------------------------------

Priority order (first match wins):
1. Table with described fields AND at least one field description → Generate
   @class + inline record in signature
2. Table with fields but NO field descriptions → Emit inline record `{...}`
   (no @class)
3. Union type (with "or"/"and") → Process with processTypeString
4. Simple type                → Add namespace prefix

--------------------------------------------------------------------------------
9. EXCLUSIONS (NOT PROCESSED)
--------------------------------------------------------------------------------

9.1 DON'T add namespace to:
    - Builtin types: string, number, boolean, table, function, userdata, light userdata, thread, nil
    - Types with dot: "love.Canvas"
    - Class names: "love.module.functionName.paramName"

9.2 DON'T process with processTypeString:
    - Class names

--------------------------------------------------------------------------------
10. DEBUG MODE
--------------------------------------------------------------------------------

10.1 Usage: lua genLOVE2dAPI.lua DEBUG

Shows:
- All collected types (knownTypes)
- Plural forms: "tables" → table[]
- Defined types (with prefix): love.Canvas, love.Image, ...
- Undefined types (used but not defined in API)

--------------------------------------------------------------------------------
11. PROCESSING PIPELINE
--------------------------------------------------------------------------------

API data → collectTypes() → knownTypes, definedTypes
                                   ↓
                        processTypeString()
                          ↓              ↓
                   plural forms    union types
                       ↓                ↓
                  addNamespaceToType()
                       ↓
                genClassForTable() (only when fields have descriptions)
                       ↓
                 genFunction()
                       ↓
                OUTPUT: library/love/*d.lua

================================================================================
END OF DETAILED TYPE PROCESSING RULES
================================================================================
]]

local HELP_TEXT = [[

LuaCATS LÖVE Generator

A tool that automatically generates LuaCATS type annotations for the LÖVE 2D API.

USAGE:
    lua genLOVE2dAPI.lua [OPTIONS] [OUTPUT_DIR]

OPTIONS:
    DEBUG             - Show debug information about type collection
    HELP              - Display this help message

COMMANDS:
    (no argument)     - Generate full API
                       Output directory: library/

    "path/to/dir"     - Generate full API to custom directory
                       Output directory: path/to/dir/

                       Examples:
                           lua genLOVE2dAPI.lua "my_api"
                           lua genLOVE2dAPI.lua "./custom/path/api"

EXAMPLES:
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

OUTPUT:
    - Generated API is placed in specified directory (default: library/)
    - Files are organized as: <output_dir>/<module>.lua
    - Each file contains LuaCATS annotations compatible with IDEs supporting LuaCATS
]]

local INTRO_TEXT = "LuaCATS LÖVE Generator. Run 'lua genLOVE2dAPI.lua HELP' to view usage."

-- Best-effort UTF-8 on Windows
pcall(function()
    os.execute("chcp 65001 > nul 2>&1")
end)

local time = os.clock()

--------------------------------------------------------------------------------
-- Type discovery
--------------------------------------------------------------------------------
local API = {
    NAME           = "love",
    ENGINE         = "love2d",
    FILE           = "love_api",
    FILE_EXT       = "lua",
    -- definition files *.d.lua for documentation and not implementation code.
    LIB_FILE_EXT   = "d.lua",
    OUTPUT_DIR     = "library",
    WIKI_LINK_NAME = "Open in Browser",
    WIKI_LINK_URL  = "https://love2d.org/wiki/",
}

setmetatable(API, {
    __index = API,
    __newindex = function()
        error("Attempt to modify a constant", 2)
    end,
})

local builtinTypes = {
    ["any"]               = true,
    ["boolean"]           = true,
    ["function"]          = true,
    ["integer"]           = true,
    ["lightuserdata"]     = true,
    ["nil"]               = true,
    ["number"]            = true,
    ["string"]            = true,
    ["table"]             = true,
    ["thread"]            = true,
    ["userdata"]          = true,
    -- alias type like defined types
    ["Variant"]           = true,
    ["cdata"]             = true,
    ["RenderTargetSetup"] = true,
}

local knownTypes   = {}
local definedTypes = {}
local pluralTypes  = {
    ["strings"] = "string",
    ["tables"]  = "table",
}
local aliasType    = {
    ["Variant"]           = "any",
    ["cdata"]             = "any",
    ["RenderTargetSetup"] = "any",
}

--------------------------------------------------------------------------------
-- Utilities
--------------------------------------------------------------------------------
local function isEmpty(s)
    return s == nil or (type(s) == "string" and s:match("^%s*$") ~= nil)
end

local function first_sentence(s)
    if isEmpty(s) then
        return ""
    end
    -- full string or up to first newline, whichever comes first
    local m = s:match("^(.-)\n") or s
    return m and m or s
end

local function trim(s)
    if isEmpty(s) then
        return ""
    end

    return first_sentence(s)
end

local function trimParam(s)
    if isEmpty(s) then
        return ""
    end

    -- replace every remaining single newline with "\n---"
    return s:gsub("\n", "\n---")
end

local function safeDesc(src)
    if isEmpty(src) then
        return ""
    end
    return "---" .. src:gsub("\n", "\n---")
end

local function stripNewlines(src)
    if isEmpty(src) then
        return ""
    end
    return string.gsub(src, "\n", " ")
end

local function countTable(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Return the separator used between module/type and function name.
-- love.window.setMode -> delimiter(true) == "."
-- RecordingDevice:getBitDepth -> delimiter(false) == ":"
local function delimiter(static)
    if static == false then
        return ":"
    end
    return "."
end

local function isIdentifier(s)
    local local_keywords = {
        ["and"]      = true,
        ["break"]    = true,
        ["do"]       = true,
        ["else"]     = true,
        ["elseif"]   = true,
        ["end"]      = true,
        ["false"]    = true,
        ["for"]      = true,
        ["function"] = true,
        ["goto"]     = true,
        ["if"]       = true,
        ["in"]       = true,
        ["local"]    = true,
        ["nil"]      = true,
        ["not"]      = true,
        ["or"]       = true,
        ["repeat"]   = true,
        ["return"]   = true,
        ["then"]     = true,
        ["true"]     = true,
        ["until"]    = true,
        ["while"]    = true,
    }
    return type(s) == "string" and s:match("^[_%a][_%w]*$") and not local_keywords[s]
end

local function convertStringToParam(s)
    if type(s) ~= "string" then
        return s
    end
    local singleQuoted = s:match("^'(.*)'$")
    if singleQuoted then
        return singleQuoted
    end
    local doubleQuoted = s:match('^"(.*)"$')
    if doubleQuoted then
        return doubleQuoted
    end
    return s
end

local function keyConvert(key)
    local t = type(key)
    if t == "number" or t == "boolean" then
        return "[" .. tostring(key) .. "]"
    end
    if t ~= "string" then
        key = tostring(key)
    end

    if isIdentifier(key) then
        return key
    end

    return "[" .. string.format("%q", key) .. "]"
end

local function aliasTypeToDef(mapping)
    local code = ""
    for alias, value in pairs(mapping) do
        code = code .. "---@alias " .. tostring(alias) .. " " .. tostring(value) .. "\n"
    end
    return code
end
--------------------------------------------------------------------------------
-- CLI
--------------------------------------------------------------------------------
local function createDirectory(path)
    local isWindows = package.config:sub(1, 1) == "\\"
    if isWindows then
        path = path:gsub("/", "\\")
        os.execute("mkdir " .. path .. " 2>nul")
    else
        os.execute("mkdir -p " .. path .. " 2>/dev/null")
    end
end

local debugMode = false
local outputDir = API.OUTPUT_DIR
for i = 1, #arg do
    local a = arg[i]
    if a == "DEBUG" then
        debugMode = true
    elseif a == "HELP" then
        io.write(HELP_TEXT, "\n")
        os.exit(0)
    else
        io.write(INTRO_TEXT, "\n")
        outputDir = a
    end
end
createDirectory(outputDir)
createDirectory(outputDir .. "/" .. API.NAME)

--------------------------------------------------------------------------------
-- Load love_api
--------------------------------------------------------------------------------
local ok, apiRequire = pcall(function()
    return require(API.FILE)
end)
if not ok then
    io.stderr:write(
        "Error: could not require '"
            .. API.FILE
            .. "'. Make sure "
            .. API.FILE
            .. "."
            .. API.FILE_EXT
            .. " is present in package.path\n"
    )
    os.exit(1)
end

--------------------------------------------------------------------------------
-- Tokenizer & type helpers
--------------------------------------------------------------------------------
local function tokenizePreserveQuoted(s)
    if not s then
        return {}
    end
    local tokens = {}
    local i = 1
    local n = #s

    while i <= n do
        local c = s:sub(i, i)

        if c == '"' or c == "'" then
            local quote = c
            local j = i + 1
            while j <= n do
                local ch = s:sub(j, j)
                if ch == "\\" then
                    j = j + 2
                elseif ch == quote then
                    break
                else
                    j = j + 1
                end
            end
            if j > n then
                tokens[#tokens + 1] = s:sub(i, n)
                i = n + 1
            else
                tokens[#tokens + 1] = s:sub(i, j)
                i = j + 1
            end
        elseif c == "(" then
            local depth = 1
            local j = i + 1
            while j <= n and depth > 0 do
                local ch = s:sub(j, j)
                if ch == "(" then
                    depth = depth + 1
                elseif ch == ")" then
                    depth = depth - 1
                end
                j = j + 1
            end
            tokens[#tokens + 1] = s:sub(i, math.min(j - 1, n))
            i = j
        else
            local word = s:match("^[^%s]+", i)
            if not word then
                break
            end
            tokens[#tokens + 1] = word
            i = i + #word
        end

        local ws = s:match("^%s*", i)
        i = i + #ws
    end

    return tokens
end

local function isPlural(typeStr, kts)
    kts = kts or knownTypes
    local base = typeStr and typeStr:match("(.+)s$")
    if base and (builtinTypes[base] or kts[base]) then
        return true, base
    end
    return false, typeStr
end

local function processTypeString(typeStr, kts)
    if not typeStr or typeStr == "" then
        return "any"
    end
    kts = kts or knownTypes

    local normalized = typeStr:gsub("%s+and%s+", " or ")
    local tokens = tokenizePreserveQuoted(normalized)

    local parts = {}
    local cur = {}
    for _, tok in ipairs(tokens) do
        if tok == "or" then
            parts[#parts + 1] = cur
            cur = {}
        else
            cur[#cur + 1] = tok
        end
    end
    parts[#parts + 1] = cur

    local out = {}
    local allPlural = true

    local function processPart(part)
        if #part == 0 then
            allPlural = false
            return "any"
        end
        if #part > 1 then
            allPlural = false
            return table.concat(part, " ")
        end

        local tok = part[1]
        if tok:match('^".*"$') or tok:match("^'.*'$") then
            allPlural = false
            return tok
        end

        local plural, base = isPlural(tok, kts)
        if plural then
            return base .. "[]"
        else
            allPlural = false
            return tok
        end
    end

    for _, part in ipairs(parts) do
        out[#out + 1] = processPart(part)
    end

    if #out == 1 then
        return out[1]
    end

    if allPlural then
        local bases = {}
        for _, v in ipairs(out) do
            bases[#bases + 1] = v:gsub("%[%]$", "")
        end
        return "(" .. table.concat(bases, "|") .. ")[]"
    end

    return table.concat(out, "|")
end

local function addNamespaceToType(typeStr)
    if not typeStr or typeStr == "" then
        return "any"
    end

    local trim_local = trim or function(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    end

    if typeStr:match('^".*"$') or typeStr:match("^'.*'$") then
        return typeStr
    end

    local function mapParts(s)
        local parts = {}
        for part in s:gmatch("([^|]+)") do
            parts[#parts + 1] = addNamespaceToType(trim_local(part))
        end
        return parts
    end

    local unionArray = typeStr:match("^%((.+)%)%[%]$")
    if unionArray then
        return "(" .. table.concat(mapParts(unionArray), "|") .. ")[]"
    end

    local compactKey = typeStr:gsub("%s+", "")
    if type(builtinTypes) == "table" and (builtinTypes[compactKey] or builtinTypes[typeStr]) then
        return compactKey
    end

    local base = typeStr:match("^(.-)%[%]$")
    if base then
        return addNamespaceToType(trim_local(base)) .. "[]"
    end

    if typeStr:find("|", 1, true) then
        return table.concat(mapParts(typeStr), "|")
    end

    -- fast rejects / keep-as-is cases
    if type(builtinTypes) == "table" and builtinTypes[typeStr] then
        return typeStr
    end
    if typeStr:find("%s") then
        return typeStr
    end
    if typeStr:find("%.") or typeStr:find("{ ", 1, true) then
        return typeStr
    end

    if (knownTypes and knownTypes[typeStr]) or (definedTypes and definedTypes[typeStr]) then
        return API.NAME .. "." .. typeStr
    end

    if typeStr:lower() == "any" then
        return "any"
    end

    return typeStr
end

local function proc(t)
    -- normalize and namespace a raw type string
    return addNamespaceToType(processTypeString(t or "any", knownTypes))
end

--------------------------------------------------------------------------------
-- Collect known types from API
--------------------------------------------------------------------------------
local function collectTypesFromVariant(variant)
    if not variant then
        return
    end

    local function addKnownFromProcessed(processed)
        for base in processed:gmatch("([%w_]+)") do
            knownTypes[base] = true
        end
    end

    local function collectType(typeStr)
        if not typeStr or typeStr == "" then
            return
        end
        if typeStr:find(" or ", 1, true) or typeStr:find(" and ", 1, true) then
            addKnownFromProcessed(processTypeString(typeStr, knownTypes))
        else
            local plural, base = isPlural(typeStr, knownTypes)
            if plural then
                pluralTypes[typeStr] = base
            end
            knownTypes[base or typeStr] = true
        end
    end

    local function collectFieldsList(list)
        for _, item in ipairs(list) do
            collectType(item.type)
            if item.table then
                for _, f in ipairs(item.table) do
                    collectType(f.type)
                end
            end
        end
    end

    if variant.arguments then
        collectFieldsList(variant.arguments)
    end

    if variant.returns then
        for _, r in ipairs(variant.returns) do
            collectType(r.type)
            if r.table then
                for _, f in ipairs(r.table) do
                    collectType(f.type)
                end
            end
            if r.arraytype and r.arraytype ~= "" then
                knownTypes[r.arraytype] = true
            end
        end
    end
end

local function collectTypes(module)
    if not module then
        return
    end

    local function addDefined(list)
        for _, item in ipairs(list or {}) do
            knownTypes[item.name] = true
            definedTypes[item.name] = true
        end
    end

    addDefined(module.types)
    addDefined(module.enums)

    for _, f in ipairs(module.functions or {}) do
        for _, v in ipairs(f.variants or {}) do
            collectTypesFromVariant(v)
        end
    end

    for _, m in ipairs(module.modules or {}) do
        collectTypes(m)
    end
end

collectTypes(apiRequire)

-- Ensure common plural forms are recorded so DEBUG shows them (per your example)
local function printDebugInfo()
    print("DEBUG: All collected types (" .. countTable(knownTypes) .. " total):")
    local tmp = {}
    for k in pairs(knownTypes) do
        tmp[#tmp + 1] = k
    end
    table.sort(tmp)
    for _, v in ipairs(tmp) do
        print("  - " .. v)
    end
    print("")

    print("DEBUG: Plural forms found in API (will be converted to arrays):")
    local tmpPlural = {}
    for k, v in pairs(pluralTypes) do
        tmpPlural[#tmpPlural + 1] = { k = k, v = v }
    end
    table.sort(tmpPlural, function(a, b)
        return a.k < b.k
    end)
    for _, it in ipairs(tmpPlural) do
        print("  - " .. it.k .. " → " .. it.v .. "[]")
    end
    print("Total plural forms: " .. countTable(pluralTypes))
    print("")

    print("DEBUG: Types starting with capital letter (defined in type files):")
    local definedCap = {}
    for k in pairs(definedTypes) do
        local first = k:sub(1, 1)
        if first == first:upper() and first ~= first:lower() then
            definedCap[#definedCap + 1] = k
        end
    end
    table.sort(definedCap)
    for _, v in ipairs(definedCap) do
        print("  - " .. API.NAME .. "." .. v)
    end
    print("Total defined capital letter types: " .. #definedCap)
    print("")

    print("DEBUG: Types starting with capital letter (used but NOT defined):")
    local undef = {}
    for k in pairs(knownTypes) do
        if not definedTypes[k] then
            local first = k:sub(1, 1)
            if first == first:upper() and first ~= first:lower() then
                undef[#undef + 1] = k
            end
        end
    end
    table.sort(undef)
    local seen = {}
    for _, v in ipairs(undef) do
        if not seen[v] then
            print("  - " .. (knownTypes[v] and (API.NAME .. "." .. v) or v))
            seen[v] = true
        end
    end
    print("Total undefined capital letter types: " .. countTable(seen))
    print("")
end

if debugMode then
    printDebugInfo()
end

--------------------------------------------------------------------------------
-- Parameter helpers
--------------------------------------------------------------------------------
local function expandParameters(arguments)
    if not arguments then
        return {}
    end
    local expanded = {}
    for _, argument in ipairs(arguments) do
        if argument.name == "..." then
            expanded[#expanded + 1] = argument
        elseif string.find(argument.name, ",") then
            for name in string.gmatch(argument.name, "%s*([^,]+)%s*") do
                expanded[#expanded + 1] = {
                    type        = argument.type,
                    name        = name,
                    description = argument.description,
                    default     = argument.default,
                    table       = argument.table,
                    callback    = argument.callback,
                }
            end
        else
            expanded[#expanded + 1] = argument
        end
    end
    return expanded
end

local function isVarargs(name)
    return name == "..."
end

local function buildCallbackType(cb)
    if not cb then
        return "fun(...)"
    end

    local parts = {}
    for _, a in ipairs(cb.arguments or {}) do
        local t = proc(a.type)
        parts[#parts + 1] = a.name and (convertStringToParam(a.name) .. ": " .. t) or t
    end

    local sig = "fun(" .. table.concat(parts, ", ") .. ")"

    local rets = {}
    for _, r in ipairs(cb.returns or {}) do
        rets[#rets + 1] = proc(r.type)
    end
    if #rets > 0 then
        sig = sig .. ": " .. table.concat(rets, ", ")
    end

    return sig
end

--------------------------------------------------------------------------------
-- Generation: functions, types, enums, modules
-- inline types; reuse return.table for param when arg.table absent; generate
-- classes for returns with field descriptions
--------------------------------------------------------------------------------
local function genClassName(moduleName, functionName, paramName)
    return moduleName .. "." .. functionName .. "." .. paramName
end

local function fieldsRequireClass(fields)
    for _, f in ipairs(fields) do
        if f.description and tostring(f.description) ~= "" then
            return true
        end
    end
    return false
end

local function appendDefaultDesc(desc, default)
    if default == nil then
        return desc or ""
    end
    desc = desc or ""
    local dstr = tostring(default)

    -- treat string "true"/"false" as boolean-like default to
    return desc .. (desc == "" and "" or " ") .. "(defaults to `" .. dstr .. "`)."
end

-- genClassForTable now accepts `static` and uses that separator when building class names/descriptions
local function genClassForTable(module, func, param, fields, desc, static)
    if not fieldsRequireClass(fields) then
        return nil, nil
    end

    local rootParam = param
    local rootClassName = module .. delimiter(static) .. func .. "." .. rootParam

    local queue = { { paramPath = param, fields = fields, desc = desc or "", depth = 0 } }
    local idx = 1
    local nodes_by_depth = {} -- nodes_by_depth[depth] = { node, ... }
    local maxDepth = 0

    while idx <= #queue do
        local node = queue[idx]
        idx = idx + 1

        if not node or type(node) ~= "table" then
        else
            local d = node.depth or 0
            nodes_by_depth[d] = nodes_by_depth[d] or {}
            table.insert(nodes_by_depth[d], node)
            if d > maxDepth then
                maxDepth = d
            end

            local nodeFields = node.fields
            if nodeFields and type(nodeFields) == "table" then
                for _, f in ipairs(nodeFields) do
                    if f and f.name ~= "..." and f.table and type(f.table) == "table" and #f.table > 0 then
                        local childParamPath = node.paramPath .. "." .. f.name
                        table.insert(queue, {
                            paramPath = childParamPath,
                            fields    = f.table,
                            desc      = f.description or "",
                            depth     = d + 1,
                        })
                    end
                end
            end
        end
    end

    local function genSingleClass(node)
        local className = module .. delimiter(true) .. func .. "." .. node.paramPath
        local lines = {}
        if node.desc and node.desc ~= "" then
            lines[#lines + 1] = ("---Options for `%s%s`."):format(module .. delimiter(static) .. func, "")
        end
        lines[#lines + 1] = ("---@class " .. className)

        -- find first non-vararg field index (positional "first" field)
        local firstNonVarFieldIdx = nil
        for idxF, f in ipairs(node.fields) do
            if f.name ~= "..." then
                firstNonVarFieldIdx = idxF
                break
            end
        end

        for i, f in ipairs(node.fields) do
            if f.name ~= "..." then
                local isOptional = (f.default ~= nil) and (i ~= firstNonVarFieldIdx)

                local ftype = f.type or "any"
                if string.find(ftype, " or ") or string.find(ftype, " and ") then
                    ftype = processTypeString(ftype, knownTypes)
                end

                -- description (first sentence) for the field itself + default if present
                local fldDesc = ""
                if f.description and f.description ~= "" then
                    fldDesc = first_sentence(f.description)
                end

                fldDesc = (f.default ~= nil) and appendDefaultDesc(fldDesc, f.default) or fldDesc
                fldDesc = trim(fldDesc)
                fldDesc = (fldDesc ~= "" and " " .. fldDesc) or ""

                if f.table and #f.table > 0 then
                    ftype = module .. delimiter(static) .. func .. "." .. node.paramPath .. "." .. f.name
                else
                    ftype = addNamespaceToType(ftype)
                end
                lines[#lines + 1] = ("---@field %s%s %s%s"):format(f.name, isOptional and "?" or "", ftype, fldDesc)
            end
        end

        return className, table.concat(lines, "\n") .. "\n\n"
    end

    local all_codes = {}
    for depth = 0, maxDepth do
        local nodes = nodes_by_depth[depth]
        if type(nodes) == "table" then
            for _, node in ipairs(nodes) do
                if type(node) == "table" then
                    local _, code = genSingleClass(node)
                    if type(code) == "string" and code ~= "" then
                        all_codes[#all_codes + 1] = code
                    end
                end
            end
        end
    end

    local classCode = table.concat(all_codes, "")
    return rootClassName, classCode
end

--------------------------------------------------------------------------------
-- Returns helpers: build inline type AND optionally className+classCode if fieldsRequireClass
--------------------------------------------------------------------------------
local function buildInlineFromFields(fields)
    if not fields then
        return "{}"
    end

    local parts = {}
    for _, f in ipairs(fields) do
        if f.name ~= "..." then
            local ftype = f.type or "any"

            if ftype:find(" or ") or ftype:find(" and ") then
                ftype = processTypeString(ftype, knownTypes)
            end

            if f.table and #f.table > 0 then
                local nestedParts = {}
                for _, nf in ipairs(f.table) do
                    if nf.name ~= "..." then
                        local nftype = nf.type
                        if nftype and (nftype:find(" or ") or nftype:find(" and ")) then
                            nftype = processTypeString(nftype, knownTypes)
                        end
                        nftype = proc(nftype)
                        nestedParts[#nestedParts + 1] = keyConvert(nf.name) .. ": " .. nftype
                    end
                end
                ftype = "{ " .. table.concat(nestedParts, ", ") .. " }"
            else
                ftype = proc(ftype)
            end

            parts[#parts + 1] = keyConvert(f.name) .. ": " .. ftype
        end
    end

    return "{ " .. table.concat(parts, ", ") .. " }"
end

local function getReturnType(ret, moduleName, functionName, returnIndex, static)
    if not ret then
        return "any", nil, nil
    end

    if ret.arraytype and (not ret.table or #ret.table == 0) then
        return proc(ret.arraytype) .. "[]", nil, nil
    end

    if ret.table and #ret.table > 0 then
        local inlineType = buildInlineFromFields(ret.table)
        local plural = select(1, isPlural(ret.type, knownTypes))
        if plural then
            inlineType = inlineType .. "[]"
        end

        if fieldsRequireClass(ret.table) then
            local paramName = (returnIndex and returnIndex > 1) and ("result" .. returnIndex) or "result"
            local className, classCode =
                genClassForTable(moduleName, functionName, paramName, ret.table, ret.description, static)
            return inlineType, className, classCode
        end

        return inlineType, nil, nil
    end

    if not ret.type then
        return "any", nil, nil
    end

    return proc(ret.type), nil, nil
end

local function genReturns(variant, moduleName, functionName, static)
    local rets = variant.returns or {}
    if #rets == 0 then
        return {}, {}
    end
    local types = {}
    local classes = {}
    for i, r in ipairs(rets) do
        local t, cname, ccode = getReturnType(r, moduleName, functionName, i, static)
        types[#types + 1] = t or "any"
        if ccode and ccode ~= "" and cname and cname ~= "" then
            classes[#classes + 1] = { name = cname, code = ccode }
        end
    end
    return types, classes
end

local function reuseReturnForArg(variant, arg, moduleName, funName)
    local returnsList = variant.returns or {}

    local exact, exactIdx
    local firstTable, firstTableIdx
    local firstArray, firstArrayIdx

    for i, r in ipairs(returnsList) do
        if r.table and #r.table > 0 and r.name == arg.name then
            exact, exactIdx = r, i
            break
        end
        if r.table and #r.table > 0 and not firstTable then
            firstTable, firstTableIdx = r, i
        end
        if r.arraytype and not firstArray then
            firstArray, firstArrayIdx = r, i
        end
    end

    local candidate = exact or firstTable or firstArray
    local candIdx = exactIdx or firstTableIdx or firstArrayIdx
    if not candidate then
        return nil, nil, nil
    end

    local paramFields, paramArrayType, paramClassName

    if candidate.table and #candidate.table > 0 then
        paramFields = candidate.table
        if fieldsRequireClass(paramFields) then
            local name = (#returnsList > 1 and candIdx and candIdx > 1) and ("result" .. candIdx) or "result"
            paramClassName = genClassName(moduleName, funName, name)
        end
    else
        paramArrayType = candidate.arraytype
    end

    return paramFields, paramArrayType, paramClassName
end

local function genFunction(moduleName, fun, static)
    local code = ""
    local funcDesc = fun.description or ""
    if fun.throws then
        funcDesc = funcDesc .. (funcDesc ~= "" and " " or "") .. "(May throw an error.)"
    end

    local classes = {}
    local classNames = {}

    local ordered = {}
    for _, variant in ipairs(fun.variants or {}) do
        ordered[#ordered + 1] = variant
    end
    table.sort(ordered, function(a, b)
        local aArgCount = #(a.arguments or {})
        local bArgCount = #(b.arguments or {})
        if aArgCount ~= bArgCount then
            return aArgCount > bArgCount
        end
        return #(a.returns or {}) > #(b.returns or {})
    end)

    local mainVariant = nil
    mainVariant = ordered[1] or mainVariant
    if mainVariant and mainVariant.returns and #mainVariant.returns > 0 then
        local _, returnedClasses = genReturns(mainVariant, moduleName, fun.name, static)
        for _, cls in ipairs(returnedClasses or {}) do
            if cls and cls.name and cls.code and not classNames[cls.name] then
                classNames[cls.name] = true
                classes[#classes + 1] = cls.code
            end
        end
    end

    -- Generate classes for table-typed arguments that have field descriptions.
    -- This makes genClassForTable produce classes for parameter tables (e.g. flags/options)
    -- when at least one field has a description (fieldsRequireClass).
    do
        local arguments = expandParameters((mainVariant and mainVariant.arguments) or {})
        for _, arg in ipairs(arguments) do
            if not isVarargs(arg.name) and arg.type == "table" then
                local paramFields = arg.table
                if not paramFields or #paramFields == 0 then
                    paramFields = reuseReturnForArg(mainVariant, arg, moduleName, fun.name)
                end

                if paramFields and #paramFields > 0 and fieldsRequireClass(paramFields) then
                    local pname, pcode =
                        genClassForTable(moduleName, fun.name, arg.name, paramFields, arg.description, static)
                    if pcode and pname and pname ~= "" and not classNames[pname] then
                        classNames[pname] = true
                        classes[#classes + 1] = pcode
                    end
                end
            end
        end
    end

    for _, classCode in ipairs(classes) do
        code = code .. classCode
    end

    code = code .. (funcDesc ~= "" and safeDesc(funcDesc) or "") .. "\n"
    code = code .. "---\n"
    code = code
        .. (
            "---["
            .. API.WIKI_LINK_NAME
            .. "]("
            .. API.WIKI_LINK_URL
            .. moduleName
            .. delimiter(static)
            .. fun.name
            .. ")\n"
        )
    code = code .. "---\n"

    local argList = ""

    for vIdx, variant in ipairs(ordered) do
        local arguments = expandParameters(variant.arguments or {})

        -- find first non-vararg index for this variant (positional "first" argument)
        local firstNonVarargIdx = nil
        for idx, a in ipairs(arguments) do
            if not isVarargs(a.name) then
                firstNonVarargIdx = idx
                break
            end
        end

        if not isEmpty(variant.description) then
            code = code .. safeDesc(variant.description) .. "\n"
        end
        if vIdx == 1 then
            code = code .. (not static and ("---@param self %s\n"):format(API.NAME .. "." .. moduleName) or "")

            for argIdx, arg in ipairs(arguments) do
                argList = (argIdx == 1) and arg.name or (argList .. ", " .. arg.name)
                -- keep '...' in signature only
                if not isVarargs(arg.name) then
                    local atype = arg.type or "any"
                    local desc = trimParam(arg.description)

                    local isOptional
                    if firstNonVarargIdx ~= nil then
                        isOptional = (argIdx ~= firstNonVarargIdx) and (arg.default ~= nil)
                    else
                        isOptional = (argIdx ~= 1) and (arg.default ~= nil)
                    end

                    if atype == "Variant" then
                        isOptional = false
                    end

                    -- Build param inline type:
                    local paramClassName
                    atype = proc(atype)

                    if atype == "table" then
                        local paramFields = arg.table
                        local paramArrayType

                        if not paramFields or #paramFields == 0 then
                            paramFields, paramArrayType, paramClassName =
                                reuseReturnForArg(variant, arg, moduleName, fun.name)
                        end

                        if paramArrayType ~= nil and (not paramFields or #paramFields == 0) then
                            atype = proc(paramArrayType) .. "[]"
                        elseif paramFields and #paramFields > 0 then
                            atype = buildInlineFromFields(paramFields)
                        else
                            atype = "table"
                        end

                        if paramClassName ~= nil then
                            local link = ("See class `" .. paramClassName .. "` for field descriptions.")
                            desc = desc .. (desc ~= "" and " " or "") .. link
                        end
                    elseif atype == "function" then
                        atype = buildCallbackType(arg.callback)
                    end

                    if arg.default ~= nil and not desc:find("%(defaults to `") then
                        desc = appendDefaultDesc(desc, arg.default)
                    end

                    atype = atype .. (isOptional and "?" or "")
                    desc = desc ~= "" and " " .. desc or ""
                    code = code .. ("---@param " .. arg.name .. " " .. atype .. desc .. "\n")
                end
            end

            -- Returns for main variant
            if variant.returns and #variant.returns > 0 then
                for ri, r in ipairs(variant.returns) do
                    local rType, rClassName = getReturnType(r, moduleName, fun.name, ri, static)
                    local rDesc, rName = "", ""
                    if r.description and tostring(r.description) ~= "" then
                        rDesc = " " .. first_sentence(r.description)
                    end

                    if r.name and tostring(r.name) ~= "" and r.name ~= "..." then
                        rName = " " .. r.name
                    end

                    -- when has no description but has a name = '...'
                    if rDesc == "" and r.name == "..." then
                        rName = " " .. r.name
                    end

                    -- Described Function Return
                    rName = rName ~= "" and rName or " #"

                    -- If there is a class for this return, append reference in comment
                    if rClassName then
                        rDesc = rDesc .. " See class `" .. rClassName .. "` for field descriptions."
                    end
                    code = code .. ("---@return " .. (rType or "any") .. rName .. rDesc .. "\n")
                end
            end
        else
            code = code .. "---@overload fun("
            if not static then
                code = code .. "self: " .. API.NAME .. "." .. moduleName .. ((#arguments > 0) and ", " or "")
            end

            local firstParam = true
            for argIdx, argument in ipairs(arguments) do
                if not isVarargs(argument.name) then
                    local atype = argument.type or "any"
                    if argument.table and #argument.table > 0 then
                        local inlineParts = {}
                        for _, f in ipairs(argument.table) do
                            if f.name ~= "..." then
                                local ftype = f.type or "any"
                                if string.find(ftype, " or ") or string.find(ftype, " and ") then
                                    ftype = processTypeString(ftype, knownTypes)
                                end
                                if f.table and #f.table > 0 then
                                    -- nested inline
                                    local nestedParts = {}
                                    for _, nf in ipairs(f.table) do
                                        if nf.name ~= "..." then
                                            local nftype = nf.type
                                            if
                                                string.find(nftype or "", " or ") or string.find(nftype or "", " and ")
                                            then
                                                nftype = processTypeString(nftype, knownTypes)
                                            end
                                            nftype = proc(nftype)
                                            nestedParts[#nestedParts + 1] = keyConvert(nf.name) .. ": " .. nftype
                                        end
                                    end
                                    ftype = "{ " .. table.concat(nestedParts, ", ") .. " }"
                                else
                                    ftype = proc(ftype)
                                end
                                inlineParts[#inlineParts + 1] = keyConvert(f.name) .. ": " .. ftype
                            end
                        end
                        atype = "{ " .. table.concat(inlineParts, ", ") .. " }"
                    else
                        atype = proc(atype)
                    end

                    code = code .. (not firstParam and ", " or "")
                    if convertStringToParam(argument.name) == argument.name then
                        code = code .. argument.name .. ": " .. atype
                    else
                        code = code .. convertStringToParam(argument.name) .. ": " .. atype .. "|" .. argument.name
                    end
                    -- Determine optional mark based on firstNonVarargIdx for this variant
                    local optionalMark = ""
                    if firstNonVarargIdx ~= nil then
                        if argument.default and (argIdx ~= firstNonVarargIdx) then
                            optionalMark = "?"
                        end
                    else
                        if argument.default and (argIdx ~= 1) then
                            optionalMark = "?"
                        end
                    end

                    code = code .. optionalMark
                    firstParam = false
                end
            end

            code = code .. ")"
            if variant.returns and #variant.returns > 0 then
                local rets = {}
                for i, ret in ipairs(variant.returns) do
                    local t, _, _ = getReturnType(ret, moduleName, fun.name, i, static)
                    rets[#rets + 1] = t
                end
                code = code .. ": " .. table.concat(rets, ", ")
            else
                code = code .. ": nil"
            end
            code = code .. "\n"
        end
    end

    code = code .. ("function " .. moduleName .. delimiter(static) .. fun.name .. "(" .. argList .. ") end\n\n")
    return code
end

local function genType(type)
    local code = ""
    if type.description then
        code = code .. safeDesc(type.description) .. "\n"
    end
    code = code .. "---\n"
    code = code .. ("---[" .. API.WIKI_LINK_NAME .. "](" .. API.WIKI_LINK_URL .. type.name .. ")\n")
    code = code .. "---\n"
    code = code .. "---@class " .. API.NAME .. "." .. type.name
    if type.supertypes then
        code = code .. " : " .. API.NAME .. "." .. table.concat(type.supertypes, ", " .. API.NAME .. ".")
    end
    code = code .. "\nlocal " .. type.name .. " = {}\n\n"
    if type.functions then
        for _, fun in ipairs(type.functions) do
            code = code .. genFunction(type.name, fun, false)
        end
    end
    return code
end

local function genEnum(enum)
    local code = ""
    if enum.description then
        code = code .. safeDesc(enum.description) .. "\n"
    end
    code = code .. "---\n"
    code = code .. ("---[" .. API.WIKI_LINK_NAME .. "](" .. API.WIKI_LINK_URL .. enum.name .. ")\n")
    code = code .. "---\n"
    code = code .. "---@alias " .. API.NAME .. "." .. enum.name .. "\n"
    for _, const in ipairs(enum.constants) do
        code = code .. "---| '\"" .. const.name .. "\"' # " .. stripNewlines(const.description) .. "\n"
    end
    code = code .. "\n"
    return code
end

local function genModule(name, api, outDir)
    print("Generating module " .. name)

    local filePath = API.NAME
    if name ~= API.NAME then
        filePath = filePath .. "/" .. name:match("^" .. API.NAME .. "%.(.+)$")
    end

    local f = assert(io.open(outDir .. "/" .. filePath .. "." .. API.LIB_FILE_EXT, "w"))
    f:write("---@meta " .. API.ENGINE .. "\n\n")

    if name == API.NAME and api and api.version and tostring(api.version) ~= "" then
        f:write("-- version: " .. tostring(api.version) .. "\n")
    end

    if api.description then
        f:write(safeDesc(api.description) .. "\n")
    end

    f:write("---\n")
    f:write("---[" .. API.WIKI_LINK_NAME .. "](" .. API.WIKI_LINK_URL .. name .. ")\n")
    f:write("---\n")

    f:write("---@class " .. name .. "\n")
    f:write(name .. " = {}\n\n")

    if api.types then
        for _, t in ipairs(api.types) do
            f:write("--region " .. API.NAME .. "." .. t.name .. "\n\n")
            f:write(genType(t))
            f:write("--endregion " .. API.NAME .. "." .. t.name .. "\n\n")
        end
    end

    if api.enums then
        for _, e in ipairs(api.enums) do
            f:write(genEnum(e))
        end
    end

    if api.modules then
        for _, m in ipairs(api.modules) do
            genModule(name .. "." .. m.name, m, outDir)
        end
    end

    if api.functions then
        for _, fn in ipairs(api.functions) do
            f:write(genFunction(name, fn, true))
        end
    end

    if api.callbacks then
        for _, fn in ipairs(api.callbacks) do
            f:write(genFunction(name, fn, true))
        end
    end

    if name == API.NAME and api then
        -- add alias for `any` types only to toplevel namespaces
        f:write(aliasTypeToDef(aliasType))
    end

    f:close()
end

genModule(API.NAME, apiRequire, API.OUTPUT_DIR)

local completed = os.clock() - time
print("--------")
print("Completed in " .. (completed * 1000) .. "ms.")
