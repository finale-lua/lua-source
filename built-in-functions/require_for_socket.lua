--[[
    This function replaces the built-in require function when luasocket is embedded in RGP Lua.
    It allows the require statement to work as if the lua sources for luasocket were installed
    in their expected folder and subfolders. The lua sources can then be installed
    in a flat folder at any location that is then attached to package.path. For example, you
    could pull them straight out of the src directory of the luasocket Github repository.
]]

__original_require = require -- choose a name that is unlikely to conflict
function require(item)
    if item ~= "socket.core" then
        local _, end_index = item:find("^socket%.")
        if end_index then
            item = item:sub(end_index+1)
        end
    end
    local required_module = nil
    local success, errormsg = pcall(function()
            required_module = __original_require(item)
        end)
    if not success then
        error(errormsg, 2) -- throw error at level of caller
    end
    return required_module
end
