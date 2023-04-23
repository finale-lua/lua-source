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
