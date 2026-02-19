--[[
EmmyLua LÖVE Generator

A tool that automatically generates EmmyLua type annotations for the LÖVE 2D game framework API.

USAGE:
    lua genEmmyAPI.lua [OPTIONS] [OUTPUT_DIR]

OPTIONS:
    DEBUG             - Show debug information about type collection
    HELP              - Display this help message

COMMANDS:
    (no argument)     - Generate full API
                       Output directory: api/

    "path/to/dir"     - Generate full API to custom directory
                       Output directory: path/to/dir/

                       Examples:
                           lua genEmmyAPI.lua "my_api"
                           lua genEmmyAPI.lua "./custom/path/api"

    HELP              - Display this help message

                       Example:
                           lua genEmmyAPI.lua HELP

EXAMPLES:
    # Generate full API to default directory
    lua genEmmyAPI.lua

    # Generate full API to custom directory
    lua genEmmyAPI.lua "my_emmylua_api"

    # Show debug info and generate to default directory
    lua genEmmyAPI.lua DEBUG

    # Show debug info and generate to custom directory
    lua genEmmyAPI.lua DEBUG "my_api"

    # Show help
    lua genEmmyAPI.lua HELP

OUTPUT:
    - Generated API is placed in specified directory (default: api/)
    - Files are organized as: <output_dir>/<module>.lua
    - Each file contains EmmyLua annotations compatible with IDEs supporting EmmyLua
]]

-- UTF-8 support
os.execute("chcp 65001 > nul 2>&1")

local time = os.clock()

print("Requiring love_api")

local api = require("love_api")

-- Get command and output directory from command line arguments
local debugMode = false
local outputDir = "api"

-- Parse arguments
for i = 1, #arg do
	local argument = arg[i]
	if argument == "DEBUG" then
		debugMode = true
	elseif argument == "HELP" then
		-- Show help and exit
		local function printHelp()
			print([[
EmmyLua LÖVE Generator

A tool that automatically generates EmmyLua type annotations for the LÖVE 2D game framework API.

USAGE:
    lua genEmmyAPI.lua [OPTIONS] [OUTPUT_DIR]

OPTIONS:
    DEBUG             - Show debug information about type collection
    HELP              - Display this help message

COMMANDS:
    (no argument)     - Generate full API
                       Output directory: api/

    "path/to/dir"     - Generate full API to custom directory
                       Output directory: path/to/dir/

                       Examples:
                           lua genEmmyAPI.lua "my_api"
                           lua genEmmyAPI.lua "./custom/path/api"

    HELP              - Display this help message

                       Example:
                           lua genEmmyAPI.lua HELP

EXAMPLES:
    # Generate full API to default directory
    lua genEmmyAPI.lua

    # Generate full API to custom directory
    lua genEmmyAPI.lua "my_emmylua_api"

    # Show debug info and generate to default directory
    lua genEmmyAPI.lua DEBUG

    # Show debug info and generate to custom directory
    lua genEmmyAPI.lua DEBUG "my_api"

    # Show help
    lua genEmmyAPI.lua HELP

OUTPUT:
    - Generated API is placed in specified directory (default: api/)
    - Files are organized as: <output_dir>/<module>.lua
    - Each file contains EmmyLua annotations compatible with IDEs supporting EmmyLua
]])
		end
		printHelp()
		os.exit(0)
	else
		-- Treat as output directory
		outputDir = argument
	end
end

local function safeDesc(src, prefix)
	prefix = prefix or ""
	return "---" .. string.gsub(src, "\n", "\n" .. prefix .. "---")
end

local function stripNewlines(src)
	return string.gsub(src, "\n", " ")
end

local function countTable(t)
	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

-- Build a set of all known types from the API
local knownTypes = {}
local definedTypes = {}
local descriptiveTypes = {}

-- List of Lua built-in types that should not have love. prefix
local builtinTypes = {
	["string"] = true,
	["number"] = true,
	["boolean"] = true,
	["table"] = true,
	["function"] = true,
	["userdata"] = true,
	["thread"] = true,
	["nil"] = true,
}

-- Normalize type by removing plural 's' if base type is standard
local function normalizeType(typeStr)
	-- Remove leading/trailing spaces
	typeStr = string.gsub(typeStr, "^%s+|%s+$", "")

	-- Check if it ends with 's' and removing it gives a standard type
	if string.len(typeStr) > 1 and string.sub(typeStr, -1) == "s" then
		local baseType = string.sub(typeStr, 1, -2)
		-- Check if base type is builtin or known
		if builtinTypes[baseType] or knownTypes[baseType] then
			return baseType
		end
	end

	return typeStr
end

-- Process type string: replace 'and' with 'or', normalize plurals
local function processTypeString(typeStr)
	-- Replace 'and' with 'or' for consistent processing
	typeStr = string.gsub(typeStr, " and ", " or ")

	-- Split by 'or' and normalize each part
	local parts = {}
	for part in string.gmatch(typeStr, "[^%s]+") do
		if part ~= "or" then
			local normalized = normalizeType(part)
			table.insert(parts, normalized)
		end
	end

	-- Reconstruct with ' or '
	if #parts > 1 then
		return table.concat(parts, " or ")
	elseif #parts == 1 then
		return parts[1]
	else
		return typeStr
	end
end

local function collectTypesFromVariant(variant)
	-- Collect types from arguments
	if variant.arguments then
		for _, argument in ipairs(variant.arguments) do
			if argument.type then
				-- First check if it has ' or ' or ' and '
				if string.find(argument.type, " or ") or string.find(argument.type, " and ") then
					-- Process union types
					local processedType = processTypeString(argument.type)
					local types = {}
					for part in string.gmatch(processedType, "[^%s|]+") do
						if part ~= "or" then
							table.insert(types, part)
						end
					end
					for _, t in ipairs(types) do
						knownTypes[t] = true
					end
				else
					-- No 'or'/'and', check if it has spaces (descriptive)
					if string.find(argument.type, " ") then
						descriptiveTypes[argument.type] = true
					else
						-- Single type
						knownTypes[argument.type] = true
					end
				end
			end
			-- Collect types from table fields in arguments
			if argument.table then
				for _, field in ipairs(argument.table) do
					if field.type then
						if string.find(field.type, " or ") or string.find(field.type, " and ") then
							local processedType = processTypeString(field.type)
							local types = {}
							for part in string.gmatch(processedType, "[^%s|]+") do
								if part ~= "or" then
									table.insert(types, part)
								end
							end
							for _, t in ipairs(types) do
								knownTypes[t] = true
							end
						else
							if string.find(field.type, " ") then
								descriptiveTypes[field.type] = true
							else
								knownTypes[field.type] = true
							end
						end
					end
				end
			end
		end
	end

	-- Collect types from returns
	if variant.returns then
		for _, ret in ipairs(variant.returns) do
			if ret.type then
				if string.find(ret.type, " or ") or string.find(ret.type, " and ") then
					local processedType = processTypeString(ret.type)
					local types = {}
					for part in string.gmatch(processedType, "[^%s|]+") do
						if part ~= "or" then
							table.insert(types, part)
						end
					end
					for _, t in ipairs(types) do
						knownTypes[t] = true
					end
				else
					if string.find(ret.type, " ") then
						descriptiveTypes[ret.type] = true
					else
						knownTypes[ret.type] = true
					end
				end
			end
			-- Collect types from table fields in returns
			if ret.table then
				for _, field in ipairs(ret.table) do
					if field.type then
						if string.find(field.type, " or ") or string.find(field.type, " and ") then
							local processedType = processTypeString(field.type)
							local types = {}
							for part in string.gmatch(processedType, "[^%s|]+") do
								if part ~= "or" then
									table.insert(types, part)
								end
							end
							for _, t in ipairs(types) do
								knownTypes[t] = true
							end
						else
							if string.find(field.type, " ") then
								descriptiveTypes[field.type] = true
							else
								knownTypes[field.type] = true
							end
						end
					end
				end
			end
		end
	end
end

local function collectTypes(module)
	if module.types then
		for _, type in ipairs(module.types) do
			knownTypes[type.name] = true
			definedTypes[type.name] = true
		end
	end
	if module.enums then
		for _, enum in ipairs(module.enums) do
			knownTypes[enum.name] = true
			definedTypes[enum.name] = true
		end
	end
	if module.functions then
		for _, fun in ipairs(module.functions) do
			if fun.variants then
				for _, variant in ipairs(fun.variants) do
					collectTypesFromVariant(variant)
				end
			end
		end
	end
	if module.modules then
		for _, m in ipairs(module.modules) do
			collectTypes(m)
		end
	end
end

collectTypes(api)

-- Add module namespace prefix to defined type
local function addNamespaceToDefinedType(type)
	-- If type already has a dot - don't modify
	if string.find(type, "%.") then
		return type
	end

	-- If type is in defined types - add love. prefix
	if definedTypes[type] then
		return "love." .. type
	end

	-- Unknown type - return as is
	return type
end

-- Add module namespace prefix to any known type
local function addNamespaceToAnyType(type)
	-- If type already has a dot - don't modify
	if string.find(type, "%.") then
		return type
	end

	-- If type is in known types - add love. prefix
	if knownTypes[type] then
		return "love." .. type
	end

	-- Unknown type - return as is
	return type
end

-- Print debug information if DEBUG mode is enabled
if debugMode then
	print("DEBUG: All collected types (" .. countTable(knownTypes) .. " total):")
	local sortedTypes = {}
	for typeName, _ in pairs(knownTypes) do
		table.insert(sortedTypes, typeName)
	end
	table.sort(sortedTypes)
	for _, typeName in ipairs(sortedTypes) do
		print("  - " .. typeName)
	end
	print("")

	print("DEBUG: Descriptive types (with spaces, not prefixed):")
	local sortedDescriptiveTypes = {}
	for typeName, _ in pairs(descriptiveTypes) do
		table.insert(sortedDescriptiveTypes, typeName)
	end
	table.sort(sortedDescriptiveTypes)
	for _, typeName in ipairs(sortedDescriptiveTypes) do
		print("  - " .. typeName)
	end
	print("Total descriptive types: " .. countTable(descriptiveTypes))
	print("")

	print("DEBUG: Types starting with capital letter (defined in type files):")
	local definedCapitalTypes = {}
	for typeName, _ in pairs(definedTypes) do
		local firstChar = string.sub(typeName, 1, 1)
		if firstChar == string.upper(firstChar) and firstChar ~= string.lower(firstChar) then
			table.insert(definedCapitalTypes, typeName)
		end
	end
	table.sort(definedCapitalTypes)
	for _, typeName in ipairs(definedCapitalTypes) do
		print("  - " .. addNamespaceToDefinedType(typeName))
	end
	print("Total defined capital letter types: " .. #definedCapitalTypes)
	print("")

	print("DEBUG: Types starting with capital letter (used but NOT defined):")
	local undefinedCapitalTypes = {}
	for typeName, _ in pairs(knownTypes) do
		if not definedTypes[typeName] then
			local firstChar = string.sub(typeName, 1, 1)
			if firstChar == string.upper(firstChar) and firstChar ~= string.lower(firstChar) then
				table.insert(undefinedCapitalTypes, typeName)
			end
		end
	end
	table.sort(undefinedCapitalTypes)
	-- Remove duplicates
	local seen = {}
	for _, typeName in ipairs(undefinedCapitalTypes) do
		if not seen[typeName] then
			print("  - " .. addNamespaceToAnyType(typeName))
			seen[typeName] = true
		end
	end
	print("Total undefined capital letter types: " .. countTable(seen))
	print("")
end

-- Add module namespace prefix to type if needed
local function addNamespaceToType(type)
	-- If type already has a dot or is a table type - don't modify
	if string.find(type, "%.") or string.find(type, "{") then
		return type
	end

	-- If type is a built-in Lua type - don't add prefix
	if builtinTypes[type] then
		return type
	end

	-- If type is descriptive (contains spaces) - don't add prefix
	if descriptiveTypes[type] then
		return type
	end

	-- If type is in known API types - add love. prefix
	if knownTypes[type] then
		return "love." .. type
	end

	-- Unknown type - return as is
	return type
end

local function getReturnType(ret)
	-- Include fields with their types when the return type is a table with known fields and types
	if ret.table then
		local s = "{"
		for i, field in ipairs(ret.table) do
			local fieldType = addNamespaceToType(field.type)
			local decl = field.name .. ":" .. fieldType
			if i == 1 then
				s = s .. decl
			else
				s = s .. ", " .. decl
			end
		end
		s = s .. "}"
		return s
	else
		-- Check if it's a descriptive type first
		if descriptiveTypes[ret.type] then
			-- It's a descriptive type - use as is
			return ret.type
		else
			-- Handle return type - process it first
			local returnType = processTypeString(ret.type)

			-- Replace 'or' with '|'
			returnType = string.gsub(returnType, " or ", " | ")

			-- Process each type in the union
			returnType = string.gsub(returnType, "(%w+)", function(word)
				return addNamespaceToType(word)
			end)

			return returnType
		end
	end
end

local function genReturns(variant)
	local returns = variant.returns
	local s = ""
	local num = 0
	if returns and #returns > 0 then
		num = #returns
		for i, ret in ipairs(returns) do
			if i == 1 then
				s = getReturnType(ret)
			else
				s = s .. ", " .. getReturnType(ret)
			end
		end
	else
		s = "nil"
	end
	return s, num
end

-- Split parameter names by comma and create separate parameter entries
local function expandParameters(arguments)
	local expanded = {}
	for _, argument in ipairs(arguments) do
		-- Check if parameter name is varargs, don't expand it
		if argument.name == "..." then
			-- Add varargs as is
			table.insert(expanded, argument)
		-- Check if parameter name contains commas (multiple parameters)
		elseif string.find(argument.name, ",") then
			-- Split by comma and create separate entries
			for name in string.gmatch(argument.name, "%s*([^,]+)%s*") do
				table.insert(expanded, {
					type = argument.type,
					name = name,
					description = argument.description,
					default = argument.default,
					table = argument.table,
				})
			end
		else
			-- Single parameter, add as is
			table.insert(expanded, argument)
		end
	end
	return expanded
end

-- Generate inline table type {field:type, field:type, ...}
local function genInlineTableType(fields)
	if not fields or #fields == 0 then
		return "{}"
	end

	local s = "{"
	for i, field in ipairs(fields) do
		local fieldType = addNamespaceToType(field.type)
		local decl = field.name .. ":" .. fieldType
		if i == 1 then
			s = s .. decl
		else
			s = s .. ", " .. decl
		end
	end
	s = s .. "}"
	return s
end

-- Check if argument name is varargs (...)
local function isVarargs(name)
	return name == "..."
end

local function genFunction(moduleName, fun, static)
	local code = safeDesc(fun.description) .. "\n"
	code = code .. "---\n"
	code = code .. "---[Open in Browser](https://love2d.org/wiki/" .. moduleName .. "." .. fun.name .. ")\n"
	code = code .. "---\n"

	local argList = ""

	local ordered = {}

	for _, variant in ipairs(fun.variants) do
		table.insert(ordered, variant)
	end

	-- Sort variants by number of arguments (descending), then by return count
	table.sort(ordered, function(a, b)
		local aArgCount = #(a.arguments or {})
		local bArgCount = #(b.arguments or {})
		if aArgCount ~= bArgCount then
			return aArgCount > bArgCount
		end
		-- If same arg count, sort by return count
		return #(a.returns or {}) > #(b.returns or {})
	end)

	for vIdx, variant in ipairs(ordered) do
		-- args
		local arguments = variant.arguments or {}
		-- Expand combined parameter names into separate entries
		arguments = expandParameters(arguments)

		if vIdx == 1 then
			-- First variant - document as main signature
			for argIdx, argument in ipairs(arguments) do
				if argIdx == 1 then
					argList = argument.name
				else
					argList = argList .. ", " .. argument.name
				end

				local type = argument.type
				local description = argument.description
				local isOptional = false

				if argument.default then
					isOptional = true
					description = description .. " (Defaults to " .. argument.default .. ".)"
				end

				-- If parameter has table fields, use inline table type
				if argument.table and #argument.table > 0 then
					type = genInlineTableType(argument.table)
				end

				-- Check if it's a descriptive type first
				if descriptiveTypes[type] then
					-- It's a descriptive type - use as is
					if isOptional then
						type = type .. "?"
					end
				else
					-- Process the type string
					local processedType = processTypeString(type)

					-- Extract first type if there are alternatives
					local baseType = string.match(processedType, "^([^%s|]+)")
					if baseType and not string.find(baseType, "{") then
						local typeToAdd = addNamespaceToType(baseType)
						if isOptional then
							typeToAdd = typeToAdd .. "?"
						end
						type = typeToAdd
					else
						local typeToAdd = addNamespaceToType(processedType)
						if isOptional then
							typeToAdd = typeToAdd .. "?"
						end
						type = typeToAdd
					end
				end

				-- Handle varargs differently
				if isVarargs(argument.name) then
					code = code .. "---@vararg " .. type .. " # " .. description .. "\n"
				else
					code = code .. "---@param " .. argument.name .. " " .. type .. " # " .. description .. "\n"
				end
			end

			-- Add return type for main signature (only if there are returns)
			local returns = variant.returns
			if returns and #returns > 0 then
				code = code .. "---@return " .. genReturns(variant) .. "\n"
			end
		else
			-- Check if variant has description different from main
			local hasDescription = variant.description and variant.description ~= fun.description

			if hasDescription then
				-- Add separator and description before overload
				code = code .. "---\n"
				code = code .. safeDesc(variant.description) .. "\n"
			end

			-- Other variants - document as overloads
			code = code .. "---@overload fun("

			-- Add self parameter for methods
			if not static then
				code = code .. "self:" .. moduleName
				if #arguments > 0 then
					code = code .. ", "
				end
			end

			local firstParam = true
			for _, argument in ipairs(arguments) do
				-- Skip varargs in overload
				if not isVarargs(argument.name) then
					local type = argument.type
					local isOptional = false

					if argument.default then
						isOptional = true
					end

					-- If parameter has table fields, use inline table type
					if argument.table and #argument.table > 0 then
						type = genInlineTableType(argument.table)
					end

					-- Check if it's a descriptive type first
					if descriptiveTypes[type] then
						-- It's a descriptive type - use as is
						if isOptional then
							type = type .. "?"
						end
					else
						-- Process the type string
						local processedType = processTypeString(type)

						-- Extract first type if there are alternatives
						local baseType = string.match(processedType, "^([^%s|]+)")
						if baseType and not string.find(baseType, "{") then
							type = addNamespaceToType(baseType)
						else
							type = addNamespaceToType(processedType)
						end
					end

					if not firstParam then
						code = code .. ", "
					end

					code = code .. argument.name .. ":" .. type
					if isOptional then
						code = code .. "?"
					end

					firstParam = false
				end
			end

			code = code .. ")"

			-- Add return type for overloads
			local returns = variant.returns
			if returns and #returns > 0 then
				local returnType = genReturns(variant)
				code = code .. ":" .. returnType
			else
				code = code .. ":nil"
			end
			code = code .. "\n"
		end
	end

	local dot = static and "." or ":"
	code = code .. "function " .. moduleName .. dot .. fun.name .. "(" .. argList .. ") end\n\n"
	return code
end

local function genType(name, type)
	local code = safeDesc(type.description) .. "\n"
	code = code .. "---\n"
	code = code .. "---[Open in Browser](https://love2d.org/wiki/" .. type.name .. ")\n"
	code = code .. "---\n"
	code = code .. "---@class " .. type.name
	if type.supertypes then
		code = code .. " : " .. table.concat(type.supertypes, ", ")
	end
	code = code .. "\nlocal " .. name .. " = {}\n"
	-- functions
	if type.functions then
		for _, fun in ipairs(type.functions) do
			code = code .. genFunction(name, fun, false)
		end
	end

	return code
end

local function genEnum(enum)
	local code = safeDesc(enum.description) .. "\n"
	code = code .. "---\n"
	code = code .. "---[Open in Browser](https://love2d.org/wiki/" .. enum.name .. ")\n"
	code = code .. "---\n"
	code = code .. "---@alias " .. enum.name .. "\n"
	for _, const in ipairs(enum.constants) do
		code = code .. '---| "' .. const.name .. '" -- ' .. stripNewlines(const.description) .. "\n"
	end
	code = code .. "\n"
	return code
end

-- Create directory recursively if it doesn't exist
local function createDirectory(path)
	local current = ""
	for part in string.gmatch(path, "[^/\\]+") do
		current = current .. part
		-- Try to create directory (ignore error if it exists)
		os.execute("mkdir " .. current .. " 2>nul || true")
		current = current .. "/"
	end
end

local function genModule(name, api, outDir)
	print("Generating module " .. name)
	local f = assert(io.open(outDir .. "/" .. name .. ".lua", "w"))
	f:write("---@meta\n")
	f:write("---@namespace love\n\n")

	if api.description then
		f:write(safeDesc(api.description) .. "\n")
	end

	f:write(name .. " = {}\n\n")

	-- types
	if api.types then
		for _, type in ipairs(api.types) do
			f:write("--region " .. type.name .. "\n\n")
			f:write(genType(type.name, type))
			f:write("--endregion " .. type.name .. "\n\n")
		end
	end

	-- enums
	if api.enums then
		for _, enum in ipairs(api.enums) do
			f:write(genEnum(enum))
		end
	end

	-- modules
	if api.modules then
		for _, m in ipairs(api.modules) do
			genModule(name .. "." .. m.name, m, outDir)
		end
	end

	-- functions
	for _, fun in ipairs(api.functions) do
		f:write(genFunction(name, fun, true))
	end

	-- Add newline at the end of the file
	f:close()
end

-- Create directory before generating
createDirectory(outputDir)

genModule("love", api, outputDir)

local completed = os.clock() - time
print("--------")
print("Completed in " .. (completed * 1000) .. "ms.")
