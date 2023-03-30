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

function table2xml(t, node, options)
    if type(t) ~= "table" then
        error ("bad argument 1 to xml2table (table expected)", 2)
    end
    options = options or {}
    if type(options) ~= "table" then
        error ("bad argument 3 to xml2table (table expected)", 2)
    end
    local doc = node:GetDocument()
    local function set_text(node, v)
        if node:ClassName() ~= "XMLElement" then
            return "top level of the table is an element, but the passed-in node is not XMLElement"
        end
        if type(v) == "number" or type(v) == "boolean" or type(v) == "string" then
            if type(v) == "boolean" then
                if options.boolyesno then
                    node:SetText(v and "yes" or "no")
                else
                    node:SetBoolText(v)
                end
            else
                node:SetText(tostring(v))
            end
        else
            return "cannot encode Lua function or userdata."
        end
        return nil
    end
    for k, v in pairs(t) do
        if k == "_attr" then
            if node:ClassName() ~= "XMLElement" then
                return "top level of the table is an element, but the passed-in node is not XMLElement"
            end
            if type(v) ~= "table" then
                return "value for attributes is not a table."
            end
            for attr_name, attr_value in pairs(v) do
                if type(attr_value) == "boolean" then
                    if options.boolyesno then
                        node:SetAttribute(attr_name, attr_value and "yes" or "no")
                    else
                        node:SetBoolAttribute(attr_name, attr_value)
                    end
                else
                    node:SetAttribute(attr_name, tostring(attr_value))
                end
            end
        elseif k == "_value" then
            local errmsg = set_text(node, v)
            if errmsg then
                return "top level of the table is an element, but the passed-in node is not XMLElement"
            end
        elseif type(v) == "table" then
            if #v > 0 then
                for _, item in ipairs(v) do
                    local child_node = doc:NewElement(k)
                    if type(item) ~= "table" then
                        local errmsg = set_text(child_node, item)
                        if errmsg then return errmsg end
                    else
                        local errmsg = table2xml(item, child_node, options)
                        if errmsg then return errorval end
                    end
                    node:InsertEndChild(child_node)
                end
            else
                local child_node = doc:NewElement(k)
                local errorval = table2xml(v, child_node, options)
                if errorval then return errorval end
                node:InsertEndChild(child_node)
            end
        else
            local child_node = doc:NewElement(k)
            local errmsg = set_text(child_node, v)
            if errmsg then return errmsg end
            node:InsertEndChild(child_node)
        end
    end
    return nil
end
