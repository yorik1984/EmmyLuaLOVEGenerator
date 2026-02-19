--[[
Main test runner
Runs all tests and reports results

USAGE:
    lua test/run_tests.lua [COMMAND] [OPTIONS] [API_DIR]

COMMANDS:
    HELP, -h, --help    Display this help message and exit

OPTIONS:
    DEBUG               Show detailed debug information during testing
                        Works with any API_DIR

ARGUMENTS:
    API_DIR             Directory containing generated API files
                        (default: api)
                        MUST be in quotes if contains spaces
                        Can be relative or absolute path
                        Examples: "api", "my_api", "./custom/path", "../other"
]]

-- UTF-8 support
os.execute("chcp 65001 > nul 2>&1")

local function printHelp()
    print([[
╔════════════════════════════════════════════════════════════════════════════╗
║           EmmyLua API Test Runner - Help                                   ║
╚════════════════════════════════════════════════════════════════════════════╝

USAGE:
    lua test/run_tests.lua [COMMAND] [OPTIONS] [API_DIR]

COMMANDS:
    HELP, -h, --help    Display this help message and exit

OPTIONS:
    DEBUG               Show detailed debug information during testing
                        Works with any API_DIR

ARGUMENTS:
    API_DIR             Directory containing generated API files
                        Default: api
                        
                        ⚠️  IMPORTANT: Path must be in QUOTES if it contains:
                            - Spaces
                            - Dots (.)
                            - Slashes (/)
                        
                        Examples:
                            "api"                    ✓
                            "my api"                 ✓ (with spaces)
                            "./generated/api"        ✓ (with dots/slashes)
                            "../other_project/api"   ✓ (with dots/slashes)
                            api                      ✗ (no quotes - may fail)

════════════════════════════════════════════════════════════════════════════

EXAMPLES:

Display Help:
    lua test/run_tests.lua HELP
    lua test/run_tests.lua -h
    lua test/run_tests.lua --help

Basic Testing:
    lua test/run_tests.lua
    lua test/run_tests.lua "api"
    lua test/run_tests.lua "my_api"

Testing with Debug Output:
    lua test/run_tests.lua DEBUG
    lua test/run_tests.lua DEBUG "my_api"
    lua test/run_tests.lua DEBUG "../other_project/api"

Testing Custom Paths (MUST USE QUOTES):
    lua test/run_tests.lua "./generated/api"
    lua test/run_tests.lua "../shared/emmylua"
    lua test/run_tests.lua "C:/Users/MyProject/api"
    lua test/run_tests.lua "path with spaces/api"

Combined Examples:
    lua test/run_tests.lua DEBUG "my api folder"
    lua test/run_tests.lua "custom/path" DEBUG
    lua test/run_tests.lua DEBUG "./api"

════════════════════════════════════════════════════════════════════════════

WHAT TESTS DO:

1. test_generated_api
   ✓ Syntax validation (loadstring check)
   ✓ EmmyLua annotations check (@meta, @class, @param, @return)
   ✓ Descriptive types validation (light userdata, etc)
   ✓ Union type validation (should use | not or)

2. test_types_validation
   ✓ Collects all types from API files
   ✓ Validates type consistency
   ✓ Checks for incomplete types
   ✓ Validates union type syntax

════════════════════════════════════════════════════════════════════════════

DEBUG MODE:

When DEBUG option is used, you'll see:

For test_generated_api:
   - Total files found
   - File names and relative paths (not full paths)
   - Test results for each file

For test_types_validation:
   - Count of standard param types
   - Count of return types
   - Count of union types
   - Count of descriptive types
   - Line numbers for each type
   - Full annotation lines
   - Detailed validation issues

════════════════════════════════════════════════════════════════════════════

QUICK REFERENCE:

Command                                  Purpose
─────────────────────────────────────────────────────────────────────────────
lua test/run_tests.lua                   Test api/ directory (default)
lua test/run_tests.lua DEBUG             Debug api/ with detailed output
lua test/run_tests.lua HELP              Show this help message
lua test/run_tests.lua "my_api"          Test my_api/ directory
lua test/run_tests.lua DEBUG "my_api"    Test my_api/ with debug output
lua test/run_tests.lua "./custom/api"    Test custom relative path
lua test/run_tests.lua DEBUG "./api"     Test with debug and custom path

════════════════════════════════════════════════════════════════════════════

OUTPUT EXPLANATION:

✅ Syntax valid               - File has valid Lua syntax
✅ Annotations valid         - File has required @meta, @class, @param, @return
✅ Descriptive types OK      - No incomplete types like "light" instead of "light userdata"
✅ Union types OK            - No ' or ' in type declarations (should be ' | ')

❌ Syntax error              - Lua syntax error found
❌ Missing annotations       - Missing required EmmyLua annotations
❌ Descriptive type issues   - Found incomplete descriptive types with line numbers
❌ Union type issues         - Found ' or ' instead of ' | ' with line numbers

Files are shown with RELATIVE PATHS ONLY:
   love.lua                  (file in api/)
   love.graphics.lua         (file in api/)
   custom/love.lua           (file in api/custom/)

════════════════════════════════════════════════════════════════════════════

TROUBLESHOOTING:

Q: "No API files found in ... directory"
A: Check that the directory exists and contains .lua files
   Make sure path is in QUOTES: lua test/run_tests.lua "my_api"

Q: Path not recognized
A: Always use QUOTES for paths with:
   - Spaces: "my folder"
   - Dots: "./api" or "../api"
   - Slashes: "path/to/api"
   
   WRONG: lua test/run_tests.lua ./api
   RIGHT: lua test/run_tests.lua "./api"

Q: "Syntax error" messages
A: Run with DEBUG to see more details about the error
   lua test/run_tests.lua DEBUG

Q: Union type issues reported
A: Check that union types use | instead of or
   Bad:  @param x number or string
   Good: @param x number | string

Q: Descriptive type issues
A: Some types need spaces, check:
   Bad:  @return light
   Good: @return light userdata

════════════════════════════════════════════════════════════════════════════

For more information, check the test files:
   test/test_generated_api.lua     - Syntax and annotation tests
   test/test_types_validation.lua  - Type validation tests

]])
end

local function getApiFiles(apiDir)
    local files = {}
    apiDir = apiDir or "api"
    
    -- Normalize path separators
    apiDir = apiDir:gsub("\\", "/")
    
    -- Remove trailing slash if present
    if apiDir:sub(-1) == "/" then
        apiDir = apiDir:sub(1, -2)
    end
    
    -- Windows
    local cmd = 'dir "' .. apiDir .. '" /b /s'
    local isWindows = package.config:sub(1,1) == '\\'
    
    if not isWindows then
        -- Linux/Mac
        cmd = 'find "' .. apiDir .. '" -type f -name "*.lua"'
    end
    
    local handle = io.popen(cmd)
    if handle then
        for line in handle:lines() do
            if line:find("%.lua$") then
                -- Normalize path separators to forward slash
                line = line:gsub("\\", "/")
                
                -- Extract relative path from API directory
                -- Find the position where apiDir ends in the path
                local apiDirPattern = apiDir:gsub("[%(%)%.%+%-%*%?%[%]%^%$|]", "%%%1")
                local startPos = line:find(apiDirPattern)
                
                if startPos then
                    -- Get everything after apiDir/
                    local relPath = line:sub(startPos + #apiDir + 1)
                    table.insert(files, relPath)
                else
                    -- Fallback: just use the filename
                    table.insert(files, line:match("([^/]+)$") or line)
                end
            end
        end
        handle:close()
    end
    
    table.sort(files)
    return files
end

local function runTests()
    print("=== Running EmmyLua API Tests ===\n")
    
    -- Parse arguments
    local debugMode = false
    local apiDir = "api"
    
    for i = 1, #arg do
        local argument = arg[i]
        
        if argument == "HELP" or argument == "-h" or argument == "--help" then
            printHelp()
            return true
        elseif argument == "DEBUG" then
            debugMode = true
        else
            -- Treat as API directory
            apiDir = argument
        end
    end
    
    local testDir = "test"
    local tests = {
        "test_generated_api",
        "test_types_validation",
    }
    
    local totalPassed = 0
    local totalFailed = 0
    
    for _, testName in ipairs(tests) do
        print("Running " .. testName .. "...")
        local testPath = testDir .. "/" .. testName .. ".lua"
        
        -- Pass debug mode and API directory to test
        local originalArg = {}
        for i = 1, #arg do
            table.insert(originalArg, arg[i])
        end
        
        arg = {apiDir}
        if debugMode then
            table.insert(arg, "DEBUG")
        end
        
        local success, result = pcall(function()
            return dofile(testPath)
        end)
        
        -- Restore original args
        arg = originalArg
        
        if success then
            if result then
                totalPassed = totalPassed + 1
                print("✅ " .. testName .. " passed\n")
            else
                totalFailed = totalFailed + 1
                print("❌ " .. testName .. " failed\n")
            end
        else
            totalFailed = totalFailed + 1
            print("❌ " .. testName .. " error: " .. result .. "\n")
        end
    end
    
    print("=== Final Results ===")
    print("Passed: " .. totalPassed)
    print("Failed: " .. totalFailed)
    print("Total: " .. (totalPassed + totalFailed))
    print()
    
    -- Show found API files
    print("=== Found API Files ===")
    local apiFiles = getApiFiles(apiDir)
    print("Directory: " .. apiDir)
    print("Total files: " .. #apiFiles)
    for _, file in ipairs(apiFiles) do
        print("  - " .. file)
    end
    print()
    
    if debugMode then
        print("(Debug mode enabled)")
        print()
    end
    
    return totalFailed == 0
end

return runTests()