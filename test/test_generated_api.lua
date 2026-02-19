--[[
Test suite for generated EmmyLua API files
Checks if generated files have valid Lua syntax
]]

-- UTF-8 support
os.execute("chcp 65001 > nul 2>&1")

local apiDir = arg[1] or "api"

local function getApiFiles(dir)
	local files = {}

	-- Normalize path
	dir = dir:gsub("\\", "/")
	if dir:sub(-1) == "/" then
		dir = dir:sub(1, -2)
	end

	-- Windows
	local cmd = 'dir "' .. dir .. '" /b /s'
	local isWindows = package.config:sub(1, 1) == "\\"

	if not isWindows then
		-- Linux/Mac
		cmd = 'find "' .. dir .. '" -type f -name "*.lua"'
	end

	local handle = io.popen(cmd)
	if handle then
		for line in handle:lines() do
			if line:find("%.lua$") then
				-- Normalize path separators
				line = line:gsub("\\", "/")

				-- Extract relative path from API directory
				local dirPattern = dir:gsub("[%(%)%.%+%-%*%?%[%]%^%$|]", "%%%1")
				local startPos = line:find(dirPattern)

				if startPos then
					local relPath = line:sub(startPos + #dir + 1)
					table.insert(files, {
						fullPath = line,
						relPath = relPath,
					})
				end
			end
		end
		handle:close()
	end

	table.sort(files, function(a, b)
		return a.relPath < b.relPath
	end)
	return files
end

local function testFileExists(filepath)
	local f = io.open(filepath, "r")
	if f then
		f:close()
		return true
	end
	return false
end

local function testFileSyntax(filepath)
	local f = io.open(filepath, "r")
	if not f then
		return false, "File not found: " .. filepath
	end

	local content = f:read("*a")
	f:close()

	local compiled, err = loadstring(content)

	if not compiled then
		return false, err or "Unknown error"
	end

	return true, "OK"
end

local function testEmmyAnnotations(filepath)
	local f = io.open(filepath, "r")
	if not f then
		return false, "File not found: " .. filepath
	end

	local content = f:read("*a")
	f:close()

	local tests = {
		meta = string.find(content, "---@meta") ~= nil,
		hasClasses = string.find(content, "---@class") ~= nil,
		hasParams = string.find(content, "---@param") ~= nil,
		hasReturns = string.find(content, "---@return") ~= nil,
		hasFunctions = string.find(content, "^function") ~= nil,
	}

	return tests
end

local function testDescriptiveTypes(filepath)
	local f = io.open(filepath, "r")
	if not f then
		return false, "File not found"
	end

	local lines = {}
	for line in f:lines() do
		table.insert(lines, line)
	end
	f:close()

	local issues = {}

	for lineNum = 1, #lines do
		local line = lines[lineNum]

		-- Check for "light userdata" (should be complete, not just "light")
		local match = line:match("@param%s+%w+%s+([^#\n]+)")
		if match and match:find("^light$") then
			table.insert(issues, {
				lineNum = lineNum,
				message = "Incomplete descriptive type: 'light' should be 'light userdata'",
				line = line,
			})
		end
	end

	return #issues == 0, issues
end

local function testUnionTypes(filepath)
	local f = io.open(filepath, "r")
	if not f then
		return false, "File not found"
	end

	local lines = {}
	for line in f:lines() do
		table.insert(lines, line)
	end
	f:close()

	local issues = {}

	for lineNum = 1, #lines do
		local line = lines[lineNum]

		-- Check @param - extract ONLY the type part (before #)
		if line:find("@param") then
			local paramType = line:match("@param%s+%w+%s+([^#]+)")
			if paramType then
				paramType = paramType:gsub("^%s+", ""):gsub("%s+$", "")

				-- Skip if type starts with { (table type - or inside is valid)
				if not paramType:find("^{") then
					-- Now check if type has ' or ' (not in table)
					if paramType:find(" or ") then
						table.insert(issues, {
							lineNum = lineNum,
							message = "Union type not converted: ' or ' should be ' | '",
							line = line,
						})
					end
				end
			end
		end

		-- Check @return - extract ONLY the type part (before comma or end)
		if line:find("@return") then
			local returnType = line:match("@return%s+([^,\n]+)")
			if returnType then
				returnType = returnType:gsub("^%s+", ""):gsub("%s+$", "")

				-- Skip if type starts with { (table type - or inside is valid)
				if not returnType:find("^{") then
					-- Check if type has ' or '
					if returnType:find(" or ") then
						table.insert(issues, {
							lineNum = lineNum,
							message = "Union type not converted: ' or ' should be ' | '",
							line = line,
						})
					end
				end
			end
		end
	end

	return #issues == 0, issues
end

local function runTests()
	print("=== EmmyLua Generated API Tests ===\n")

	local testFiles = getApiFiles(apiDir)

	if #testFiles == 0 then
		print("⚠️  No API files found in " .. apiDir .. "/ directory")
		return false
	end

	local passed = 0
	local failed = 0

	for _, fileData in ipairs(testFiles) do
		local testFile = fileData.fullPath
		local displayFile = fileData.relPath

		if not testFileExists(testFile) then
			-- Skip if file doesn't exist
		else
			print("Testing: " .. displayFile)

			-- Test syntax
			local syntaxOk, syntaxMsg = testFileSyntax(testFile)
			if syntaxOk then
				print("  ✅ Syntax valid")
				passed = passed + 1
			else
				print("  ❌ Syntax error:")
				print("     Error: " .. syntaxMsg)
				failed = failed + 1
			end

			-- Test annotations
			local annotations = testEmmyAnnotations(testFile)
			if annotations.meta and annotations.hasParams and annotations.hasReturns then
				print("  ✅ Annotations valid")
				passed = passed + 1
			else
				print("  ❌ Missing annotations")
				if not annotations.meta then
					print("     - Missing @meta")
				end
				if not annotations.hasParams then
					print("     - Missing @param")
				end
				if not annotations.hasReturns then
					print("     - Missing @return")
				end
				failed = failed + 1
			end

			-- Test descriptive types
			local descOk, descIssues = testDescriptiveTypes(testFile)
			if descOk then
				print("  ✅ Descriptive types OK")
				passed = passed + 1
			else
				print("  ❌ Descriptive type issues (" .. #descIssues .. " found):")
				for _, issue in ipairs(descIssues) do
					print("     Line " .. issue.lineNum .. ": " .. issue.message)
					print("     " .. issue.line)
				end
				failed = failed + 1
			end

			-- Test union types
			local unionOk, unionIssues = testUnionTypes(testFile)
			if unionOk then
				print("  ✅ Union types OK")
				passed = passed + 1
			else
				print("  ❌ Union type issues (" .. #unionIssues .. " found):")
				for _, issue in ipairs(unionIssues) do
					print("     Line " .. issue.lineNum .. ": " .. issue.message)
					print("     " .. issue.line)
				end
				failed = failed + 1
			end

			print()
		end
	end

	print("=== Test Results ===")
	print("Passed: " .. passed)
	print("Failed: " .. failed)
	print("Total files tested: " .. #testFiles)

	return failed == 0
end

return runTests()
