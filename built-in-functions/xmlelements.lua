function xmlelements(node, nodename)
    local child = node and node:FirstChildElement(nodename) or nil
    if child then child = child:ToElement() end -- in case node is XMLHandle
    return function()
        local current_child = child
        if child then
            child = child:NextSiblingElement(nodename)
        end
        return current_child
    end
end

function xmlattributes(node)
    node = node and node:ToElement() or nil
    local attr = node and node:FirstAttribute() or nil
    return function()
        local current_attr = attr
        if attr then
            attr = attr:Next()
        end
        return current_attr
    end
end

function xml2table(node, options)
    options = options or {}
    if type(options) ~= "table" then
        error ("bad argument 2 to xml2table (table expected)", 2)
    end
    if not node then return "" end
    local booltrue = options.boolyesno and "yes" or "true"
    local boolfalse = options.boolyesno and "no" or "false"
    local retval
    local function retval_to_table()
        if not retval then retval = {} end
        if type(retval) ~= "table" then
            retval = { _value = retval }
        end
    end
    local function getval(val)
        if options.usestrings or type(val) ~= "string" then
            return val
        end
        local val_as_number = tonumber(val)
        if val_as_number then
            return val_as_number
        end
        if val == booltrue then return true end
        if val == boolfalse then return false end
        return val
    end
    local element = node:ToElement() -- in case node is an XMLHandle
    if element then
        retval = getval(element:GetText())
        for attr in xmlattributes(element) do
            retval_to_table()
            if not retval._attr then retval._attr = {} end
            retval._attr[attr:Name()] = getval(attr:Value())
        end
    end
    local gotmulti = false
    for child in xmlelements(node) do
        retval_to_table()
        local name = child:Name()
        local childtab = xml2table(child, options)
        if childtab ~= nil then
            if retval[name] == nil then
                retval[name] = childtab
            else
                if not gotmulti then
                    retval[name] = { retval[name] }
                end
                table.insert(retval[name], childtab)
                gotmulti = true
            end
        end
    end
    return retval
end
