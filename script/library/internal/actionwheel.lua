local aw = {}
local nums = {}
nums.pages = {}
nums.paths = { "root" }
nums.actionToggles = {}
nums.actionNums = {}
nums.nowName = nil
nums.actions = {}
nums.backActions = {}
local ping = require("script.ping")
local setpingnum = ping.setnum

ping.on("aw.", function(name, value)
	local g, k = name:match("^aw%.([^%.]+)%.(.+)$")
	if not g then return end

	aw.setnum(g, k, value, false)

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
		if p then setpingnum("aw." .. g .. "." .. k, v, false) end
	else
		nums[g] = v
		if p then setpingnum("aw." .. g, v, false) end
	end
end

function aw.newToggleAction(topage, to, name, item, default, r, g, b, lighten)
	local open = topage:newAction()
	open:setTitle(name)

	if aw.getnum("actionToggles", to) == nil then
		aw.setnum("actionToggles", to, (default or false), false)
	end

	open:setToggled(aw.getnum("actionToggles", to))

	open:setOnLeftClick(function()
		local v = not aw.getnum("actionToggles", to)
		aw.setnum("actionToggles", to, v, true)
		open:setToggled(v)
	end)

	open:setItem(item)
	aw.setActionColor(open, r, g, b, lighten)
	aw.setnum("actions", to, open, false)
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

function aw.newActionPage(topage, id, name, item, r, g, b, lighten)
	local paths = aw.getnum("paths", nil)
	local subpage = action_wheel:newPage()
	local backb = subpage:newAction()
	local open = topage:newAction()
	aw.setnum("backActions", id, backb, false)

	open:setTitle(name)
	open:setOnLeftClick(function()
		aw.openPage(id)
	end):setItem(item)
	aw.setActionColor(open, r, g, b, lighten)

	backb:setOnLeftClick(function()
		action_wheel:setPage(topage)
		if #paths ~= 1 then
			table.remove(paths, #paths)
		end
	end)
	backb:setItem("minecraft:arrow")

	aw.setnum("pages", id, subpage, false)
	return subpage
end

function aw.newNumAction(topage, to, name, item, default, r, g, b, lighten)
	local open = topage:newAction()

	if aw.getnum("actionNums", to) == nil then
		aw.setnum("actionNums", to, default, false)
	end

	local function updateTitle()
		open:setTitle(name .. " now:" .. tostring(aw.getnum("actionNums", to)))
	end

	updateTitle()

	open:setOnLeftClick(function()
		local v = aw.getnum("actionNums", to) + 1
		aw.setnum("actionNums", to, v, true)
		updateTitle()
	end)

	open:setOnRightClick(function()
		local v = aw.getnum("actionNums", to) - 1
		aw.setnum("actionNums", to, v, true)
		updateTitle()
	end)

	open:setItem(item)
	aw.setActionColor(open, r, g, b, lighten)
	aw.setnum("actions", to, open, false)
end

function aw.newAction(topage, to, name, item, Lfun, Rfun, r, g, b, lighten)
	local open = topage:newAction()
	open:setTitle(name)

	if Lfun ~= nil then
		open:setOnLeftClick(Lfun)
	end
	if Rfun ~= nil then
		open:setOnRightClick(Rfun)
	end

	open:setItem(item)
	aw.setActionColor(open, r, g, b, lighten)
	aw.setnum("actions", to, open, false)
end

function aw.openPage(name)
	local page = aw.getnum("pages", name)
	local backb = aw.getnum("backActions", name)
	local paths = aw.getnum("paths", nil)

	if name == "root" then
		while #paths > 1 do
			table.remove(paths, #paths)
		end
		action_wheel:setPage(page)
		return
	end

	while #paths > 1 do
		table.remove(paths, #paths)
	end
	table.insert(paths, name)

	if backb ~= nil then
		backb:setTitle("Back\n§8path(now): " .. table.concat(paths, "/"))
	end

	action_wheel:setPage(page)
end

function aw.delall()
	aw.setnum("pages", nil, {}, false)
	aw.setnum("paths", nil, { "root" }, false)
	aw.setnum("actionToggles", nil, {}, false)
	aw.setnum("actionNums", nil, {}, false)
	aw.setnum("actions", nil, {}, false)
	aw.setnum("backActions", nil, {}, false)
	aw.setnum("nowName", nil, nil, false)
end

return aw
