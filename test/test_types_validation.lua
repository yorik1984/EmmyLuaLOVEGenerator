--[[
Advanced test for type validation
Checks if all types are correctly categorized
]]

-- UTF-8 support
os.execute("chcp 65001 > nul 2>&1")

local debugMode = arg[1] == "DEBUG"

local function collectTypesFromFile(filepath)
    local f = io.open(filepath, 'r')
    if not f then return nil end
    
    local lines = {}
    for line in f:lines() do
        table.insert(lines, line)
    end
    f:close()
    
    local types = {
        params = {},
        returns = {},
        descriptive = {},
        unions = {},
    }
    
    -- Process each line
    for lineNum = 1, #lines do
        local line = lines[lineNum]
        
        -- Check for @param
        local paramType = line:match("@param%s+%w+%s+([^#\n]+)")
        if paramType then
            paramType = paramType:gsub("^%s+", ""):gsub("%s+$", "")
            if paramType:find(" ") and not paramType:find("|") then
                table.insert(types.descriptive, {value = paramType, line = lineNum, fullLine = line})
            elseif paramType:find("|") then
                table.insert(types.unions, {value = paramType, line = lineNum, fullLine = line})
            else
                table.insert(types.params, {value = paramType, line = lineNum, fullLine = line})
            end
        end
        
        -- Check for @return
        local returnType = line:match("@return%s+([^\n]+)")
        if returnType then
            returnType = returnType:gsub("^%s+", ""):gsub("%s+$", "")
            if returnType:find(" ") and not returnType:find("|") then
                table.insert(types.descriptive, {value = returnType, line = lineNum, fullLine = line})
            elseif returnType:find("|") then
                table.insert(types.unions, {value = returnType, line = lineNum, fullLine = line})
            else
                table.insert(types.returns, {value = returnType, line = lineNum, fullLine = line})
            end
        end
    end
    
    return types
end

local function runTypeTests()
    print("=== Type Validation Tests ===\n")
    
    local mainFile = "api/love.lua"
    if not io.open(mainFile) then
        print("⚠️  Main API file not found: " .. mainFile)
        print("Skipping type validation tests\n")
        return true
    end
    
    local types = collectTypesFromFile(mainFile)
    
    if debugMode then
        print("DEBUG: Found types in " .. mainFile .. "\n")
        
        print("Standard param types (" .. #types.params .. "):")
        for _, t in ipairs(types.params) do
            print("  Line " .. t.line .. ": " .. t.value)
            print("     " .. t.fullLine)
        end
        print()
        
        print("Return types (" .. #types.returns .. "):")
        for _, t in ipairs(types.returns) do
            print("  Line " .. t.line .. ": " .. t.value)
            print("     " .. t.fullLine)
        end
        print()
        
        print("Union types (" .. #types.unions .. "):")
        for _, t in ipairs(types.unions) do
            print("  Line " .. t.line .. ": " .. t.value)
            print("     " .. t.fullLine)
        end
        print()
        
        print("Descriptive types (" .. #types.descriptive .. "):")
        for _, t in ipairs(types.descriptive) do
            print("  Line " .. t.line .. ": " .. t.value)
            print("     " .. t.fullLine)
        end
        print()
    end
    
    -- Validation checks
    local issues = 0
    
    -- Check for 'or' instead of '|'
    for _, t in ipairs(types.params) do
        if t.value:find(" or ") then
            print("❌ Line " .. t.line .. ": Found ' or ' instead of '|'")
            print("   Type: " .. t.value)
            print("   " .. t.fullLine)
            issues = issues + 1
        end
    end
    
    -- Check for 'and' instead of '|'
    for _, t in ipairs(types.params) do
        if t.value:find(" and ") then
            print("❌ Line " .. t.line .. ": Found ' and ' instead of '|'")
            print("   Type: " .. t.value)
            print("   " .. t.fullLine)
            issues = issues + 1
        end
    end
    
    -- Check for incomplete descriptive types
    for _, t in ipairs(types.descriptive) do
        if t.value == "light" or t.value == "user" or t.value == "data" then
            print("❌ Line " .. t.line .. ": Incomplete descriptive type")
            print("   Type: " .. t.value)
            print("   " .. t.fullLine)
            issues = issues + 1
        end
    end
    
    print("=== Results ===")
    print("Issues found: " .. issues)
    print()
    
    return issues == 0
end

return runTypeTests()