--Load moonscript libraries

local module_table = {
	string = string,
	math = math,
	table = table,
	debug = debug,
	jit = jit
}
local special_files = {
	lpeg = "lulpeg/lulpeg.lua"
}
function require_moonscript(name)
	if module_table[name] then return module_table[name] end
	
	local filename
	if special_files[name] then
		filename = special_files[name]
	else
		filename = "moonscript/" .. name:gsub("%.", "/") .. ".lua"
	end
	
	local foo = CompileFile(filename)
	if foo then
		module_table[name] = foo() or true
		return module_table[name]
	end
end

local np = newproxy
newproxy = nil
load = function(str) return CompileString(str, "Lulpeg") end
require_moonscript("moonscript.base")
load = nil
newproxy = np

SF.MoonscriptToLua = module_table["moonscript.base"].to_lua
