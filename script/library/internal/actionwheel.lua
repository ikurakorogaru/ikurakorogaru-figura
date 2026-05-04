local aw = {}
local nums = {}
nums.pages = {}
nums.paths = { "root" }
nums.actionToggles = {}
nums.actionNums = {}
nums.nowName = nil
nums.actions = {}
nums.backActions = {}

local pageIds = {}

local ping = require("script.library.internal.ping")
local setpingnum = ping.setnum

function aw.setNumById(pageId, id, value, p)
    aw.setnum("actionNums", pageId .. "__" .. id, value, p)
end

function aw.setToggleById(pageId, id, value, p)
    aw.setnum("actionToggles", pageId .. "__" .. id, value, p)
end

function aw.getToggleById(pageId, id)
    return aw.getnum("actionToggles", pageId .. "__" .. id)
end

function aw.getNumById(pageId, id)
    return aw.getnum("actionNums", pageId .. "__" .. id)
end

function aw.getToggle(page, id)
    return aw.getnum("actionToggles", scopedId(page, id))
end

function aw.getNum(page, id)
    return aw.getnum("actionNums", scopedId(page, id))
end

local function joinId(parentId, id)
    if parentId == nil or parentId == "" or parentId == "root" then
        return "root_" .. id
    end
    return parentId .. "_" .. id
end

local function splitPath(id)
    local paths = {}

    for part in string.gmatch(id, "[^_]+") do
        table.insert(paths, part)
    end

    if #paths == 0 then
        table.insert(paths, "root")
    end

    return paths
end

local function getPageId(page)
    return pageIds[page] or "root"
end

local function scopedId(page, id)
    return getPageId(page) .. "__" .. id
end

ping.on("aw.", function(name, value)
    local g, k = name:match("^aw%.([^%.]+)%.(.+)$")
    if not g then return end

    aw.setnum(g, k, value, nil)

    if g == "actionToggles" then
        local action = aw.getnum("actions", k)
        if action then
            action:setToggled(value)
        end
    end

    if g == "actionNums" then
        local action = aw.getnum("actions", k)
        if action then
            action:setTitle(k .. " now:" .. tostring(value))
        end
    end
end)

function aw.getnum(g, k)
    if k ~= nil then
        return nums[g][k]
    else
        return nums[g]
    end
end

function aw.setnum(g, k, v, p)
    if nums[g] == nil then
        nums[g] = {}
    end

    if k ~= nil then
        nums[g][k] = v
        if p ~= nil then setpingnum("aw." .. g .. "." .. k, v, p) end
    else
        nums[g] = v
        if p ~= nil then setpingnum("aw." .. g, v, p) end
    end
end

function aw.newToggleAction(topage, to, name, item, default, r, g, b, lighten)
    local open = topage:newAction()
    open:setTitle(name)

    local sid = scopedId(topage, to)

    if aw.getnum("actionToggles", sid) == nil then
        aw.setnum("actionToggles", sid, (default or false), nil)
        ping.setdefault("aw.actionToggles." .. sid, (default or false))
    end

    open:setToggled(aw.getnum("actionToggles", sid))

    open:setOnLeftClick(function()
        local v = not aw.getnum("actionToggles", sid)
        aw.setnum("actionToggles", sid, v, true)
        open:setToggled(v)
    end)

    open:setItem(item)
    aw.setActionColor(open, r, g, b, lighten)
    aw.setnum("actions", sid, open, nil)
end

function aw.setRootPage(page)
    pageIds[page] = "root"
    aw.setnum("pages", "root", page, nil)
end

function aw.setActionColor(action, r, g, b, lighten)
    r = r or 255
    g = g or 255
    b = b or 255

    local nr = r / 255
    local ng = g / 255
    local nb = b / 255

    local delta = 0.255
    local op = lighten and math.min or math.max
    local base = lighten and 1 or 0
    local adjust = lighten and delta or -delta

    local hr = op(nr + adjust, base)
    local hg = op(ng + adjust, base)
    local hb = op(nb + adjust, base)

    action:setColor(nr, ng, nb)
    action:setHoverColor(hr, hg, hb)
    action:setToggleColor(hr, hg, hb)
end

function aw.initRoot()
    local root = action_wheel:newPage()
    pageIds[root] = "root"
    aw.setnum("pages", "root", root, nil)
    action_wheel:setPage(root)
    return root
end

function aw.newActionPage(topage, id, name, item, r, g, b, lighten)
    local parentId = getPageId(topage)
    local fullId = joinId(parentId, id)

    local subpage = action_wheel:newPage()
    local backb = subpage:newAction()
    local open = topage:newAction()

    pageIds[subpage] = fullId
    aw.setnum("backActions", fullId, backb, nil)

    open:setTitle(name)
    open:setOnLeftClick(function()
        aw.openPage(fullId)
    end):setItem(item)
    aw.setActionColor(open, r, g, b, lighten)

    backb:setOnLeftClick(function()
        local paths = aw.getnum("paths", nil)
        if #paths ~= 1 then
            table.remove(paths, #paths)
        end

        action_wheel:setPage(topage)

        local parentBack = aw.getnum("backActions", parentId)
        if parentBack ~= nil then
            parentBack:setTitle("Back\n§8path(now): " .. table.concat(paths, "/"))
        end
    end)

    backb:setItem("minecraft:arrow")
    aw.setnum("pages", fullId, subpage, nil)

    return subpage
end

function aw.newNumAction(topage, to, name, item, default, r, g, b, lighten)
    local open = topage:newAction()
    local sid = scopedId(topage, to)

    if aw.getnum("actionNums", sid) == nil then
        aw.setnum("actionNums", sid, default, nil)
        ping.setdefault("aw.actionNums." .. sid, default)
    end

    local function updateTitle()
        open:setTitle(name .. " now:" .. tostring(aw.getnum("actionNums", sid)))
    end

    updateTitle()

    open:setOnLeftClick(function()
        local v = aw.getnum("actionNums", sid) + 1
        aw.setnum("actionNums", sid, v, true)
        updateTitle()
    end)

    open:setOnRightClick(function()
        local v = aw.getnum("actionNums", sid) - 1
        aw.setnum("actionNums", sid, v, true)
        updateTitle()
    end)

    open:setItem(item)
    aw.setActionColor(open, r, g, b, lighten)
    aw.setnum("actions", sid, open, nil)
end

function aw.newAction(topage, to, name, item, Lfun, Rfun, r, g, b, lighten)
    local open = topage:newAction()
    open:setTitle(name)

    local sid = scopedId(topage, to)

    if Lfun ~= nil then
        open:setOnLeftClick(Lfun)
    end
    if Rfun ~= nil then
        open:setOnRightClick(Rfun)
    end

    open:setItem(item)
    aw.setActionColor(open, r, g, b, lighten)
    aw.setnum("actions", sid, open, nil)
end

function aw.openPage(name)
    local page = aw.getnum("pages", name)
    local backb = aw.getnum("backActions", name)

    if name == "root" then
        aw.setnum("paths", nil, { "root" }, nil)
        action_wheel:setPage(page)
        return
    end

    aw.setnum("paths", nil, splitPath(name), nil)

    if backb ~= nil then
        backb:setTitle("Back\n§8path(now): " .. table.concat(aw.getnum("paths", nil), "/"))
    end

    action_wheel:setPage(page)
end

function aw.delall()
    aw.setnum("pages", nil, {}, nil)
    aw.setnum("paths", nil, { "root" }, nil)
    aw.setnum("actionToggles", nil, {}, nil)
    aw.setnum("actionNums", nil, {}, nil)
    aw.setnum("actions", nil, {}, nil)
    aw.setnum("backActions", nil, {}, nil)
    aw.setnum("nowName", nil, nil, nil)
end

return aw
