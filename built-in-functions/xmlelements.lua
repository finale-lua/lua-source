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
        error ("xml2table received options that were not in a table.", 1)
    end
    if not node then return "" end
    local retval
    local function retval_to_table()
        if not retval then retval = {} end
        if type(retval) ~= "table" then
            retval = { _value = retval }
        end
    end
    local function getval(val)
        if not options.usenumbers then
            return val
        end
        val_as_number = tonumber(val)
        if val_as_number then
            return val_as_number
        end
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
        if not retval[name] then
            retval[name] = xml2table(child, options)
        else
            if not gotmulti then
                retval[name] = { retval[name] }
            end
            table.insert(retval[name], xml2table(child, options))
            gotmulti = true
        end
    end
    return retval or ""
end
