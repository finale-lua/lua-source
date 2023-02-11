--[[
    These functions are converted to rgplua_built_in_functions.xxd by means of the Unix xxd command.
    They were originally scraped out of the jwlua64 binary for macOS.
]]

finaleplugin = {} -- allows the plugin to create its header

function dumpproperties(o, include_bases)
    if type(o) ~= "userdata" then return nil end
    if o["ClassName"] == nil then return nil end
    local classname = o:ClassName()
    for k,v in pairs(_G.finale) do
        if k == classname then
            local returnval = {}
            local populate_returnval
            populate_returnval = function(classtable)
                if include_bases then
                    local parent_table = classtable.__parent
                    if parent_table then
                        for parent_name, _ in pairs(parent_table) do
                            populate_returnval(_G.finale[parent_name])
                        end
                    end
                end
                -- include this instance's properties last, so that parent properties of the same name are overwritten
                local props = classtable.__propget -- with JW Lua v0.54 and earlier, this would have been v.__class.__propget
                if props == nil then return end
                for k1, v1 in pairs(props) do
                    -- Some classes have properties that cannot be called in lower Finale versions, so skip any errors.
                    -- (An example is FCGeneralPrefs.)
                    local success, value = pcall(function() return o[k1] end)
                    if success then returnval[k1] = value end
                end
            end
            populate_returnval(v)
            return returnval
        end
    end
    return nil
end

function pairsbykeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0
    local iter = function ()
            i = i + 1
            if a[i] == nil then return nil
            else return a[i], t[a[i]]
        end
    end
    return iter
end

function eachentry(region, layer)
    local measure = region.StartMeasure
    local slotno = region:GetStartSlot()
    local i = 0
    local layertouse = 0
    if layer ~= nil then layertouse = layer end
    local c = finale.FCNoteEntryCell(measure, region:CalcStaffNumber(slotno))
    c:SetLoadLayerMode(layertouse)
    c:Load()
    return function ()
        while true do
            i = i + 1;
            local returnvalue = c:GetItemAt(i - 1)
            if returnvalue ~= nil then
                if (region:IsEntryPosWithin(returnvalue)) then return returnvalue end
            else
                measure = measure + 1
                if measure > region.EndMeasure then
                    measure = region.StartMeasure
                    slotno = slotno + 1
                    if (slotno > region:GetEndSlot()) then return nil end
                    c = finale.FCNoteEntryCell(measure, region:CalcStaffNumber(slotno))
                    c:SetLoadLayerMode(layertouse)
                    c:Load()
                    i = 0
                else
                    c = finale.FCNoteEntryCell(measure, region:CalcStaffNumber(slotno))
                    c:SetLoadLayerMode(layertouse)
                    c:Load()
                    i = 0
                end
            end
        end
    end
end

function eachentrysaved(region, layer)
    local measure = region.StartMeasure
    local slotno = region:GetStartSlot()
    local i = 0
    local layertouse = 0
    if layer ~= nil then layertouse = layer end
    local c = finale.FCNoteEntryCell(measure, region:CalcStaffNumber(slotno))
    c:SetLoadMirrors(false)
    c:SetLoadLayerMode(layertouse)
    c:Load()
    return function ()
        while true do
            i = i + 1;
            local returnvalue = c:GetItemAt(i - 1)
            if returnvalue ~= nil then
                if (region:IsEntryPosWithin(returnvalue)) then return returnvalue end
            else
                c:DeleteAllNullEntries()
                c:Save()
                measure = measure + 1
                if measure > region.EndMeasure then
                    measure = region.StartMeasure
                    slotno = slotno + 1
                    if (slotno > region:GetEndSlot()) then return nil end
                    c = finale.FCNoteEntryCell(measure, region:CalcStaffNumber(slotno))
                    c:SetLoadLayerMode(layertouse)
                    c:Load()
                    i = 0
                else
                    c = finale.FCNoteEntryCell(measure, region:CalcStaffNumber(slotno))
                    c:SetLoadLayerMode(layertouse)
                    c:Load()
                    i = 0
                end
            end
        end
    end
end
    
function loadall(t)
    if t == nil then return nil end
    if t["LoadAll"] == nil then return nil end
    if t["GetItemAt"] == nil then return nil end
    t:LoadAll()
    local i = 0
    return function ()
        i = i + 1; return t:GetItemAt(i - 1)
    end
end

function loadallforregion(t, r)
    if t == nil then return nil end
    if t["LoadAllForRegion"] == nil then return nil end
    if t["GetItemAt"] == nil then return nil end
    t:LoadAllForRegion(r)
    local i = 0
    return function ()
        i = i + 1; return t:GetItemAt(i - 1)
    end
end

function each(t)
    if t == nil then return nil end
    if t["GetItemAt"] == nil then return nil end
    local i = 0
    return function ()
        i = i + 1; return t:GetItemAt(i - 1)
    end
end

function eachbackwards(t)
    if t == nil then return nil end
    if t["GetItemAt"] == nil then return nil end
    if t["GetCount"] == nil then return nil end
    local i = t:GetCount()
    return function ()
        i = i - 1; return t:GetItemAt(i)
    end
 end
 
 function coll2table(t)
    local returnval = {}
    local i = 1
    for v in each(t) do
        returnval[i] = v
        i = i + 1
    end
    return returnval
end

function eachcell(region)
    local measure = region.StartMeasure - 1
    local slotno = region:GetStartSlot()
    return function()
        measure = measure + 1
        if measure > region.EndMeasure then
            measure = region.StartMeasure
            slotno = slotno + 1
            if slotno > region:GetEndSlot() then return nil end
        end
        return measure, region:CalcStaffNumber(slotno)
    end
end

function eachstaff(region)
    local measure = region.StartMeasure
    local slotno = region:GetStartSlot() - 1
    return function ()
        while true do
            slotno = slotno + 1
            if slotno <= region:GetEndSlot() then
                local staff_num = region:CalcStaffNumber(slotno)
                if staff_num > 0 then
                    return staff_num
                end
            end
            return nil
        end
    end
end

--[[
-- replacement for known bit32 functions in the Finale lua world that uses Lua 5.2
-- uncomment if we ever update to Lua 5.3 or higher.
bit32 = {
   band = function(x, y) return x & y end,
   bor = function(x, y) return x | y end,
   rshift = function(x, y) return x >> y end,
   lshift = function(x, y) return x << y end
}
]]
