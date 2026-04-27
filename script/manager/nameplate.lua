local manager = require("./imports")
local getnum = manager.actionwheel.getnum
local np = {}
np.setname = manager.nameplate.setname
np.addname = manager.nameplate.addname
np.nowname = manager.nameplate.nowname
local t = 0
local at = 0
local name = {}
local textname = ""
local nameCol = "#667534"
local accessory = ""

function pings.changeNameCol(r, g, b)
	nameCol = rgbToHex(r / 255, g / 255, b / 255)
end

function pings.setAccessory(a)
	accessory = a
end

function pings.changeName(iname)
	textname = iname
end

local function hsvToHex(h, s, v)
	local r, g, b

	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)

	i = i % 6

	if i == 0 then
		r, g, b = v, t, p
	elseif i == 1 then
		r, g, b = q, v, p
	elseif i == 2 then
		r, g, b = p, v, t
	elseif i == 3 then
		r, g, b = p, q, v
	elseif i == 4 then
		r, g, b = t, p, v
	elseif i == 5 then
		r, g, b = v, p, q
	end

	return string.format("#%02X%02X%02X", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255))
end

function rgbToHex(r, g, b)
	return string.format("#%02X%02X%02X", r, g, b)
end

-- name.rainbow --
local function rainbowName(text, rainbowColorInversion, move)
	local nameText = {}
	for i = 1, #text do
		local col
		local myText = string.sub(text, i, i)
		if move then
			if rainbowColorInversion then
				col = hsvToHex((i / #text - t / 10 + 0.5) % 1, 0.5, 1)
			else
				col = hsvToHex((i / #text - t / 10) % 1, 0.5, 1)
			end
		else
			if rainbowColorInversion then
				col = hsvToHex((i / #text + 0.5) % 1, 0.5, 1)
			else
				col = hsvToHex(i / #text, 0.5, 1)
			end
		end
		table.insert(nameText, {
			text = myText,
			color = col
		})
	end
	return nameText
end

local function JsonMerge(Json1, Json2)
	local output = {}
	if Json1 ~= nil then
		for _, v in ipairs(Json1) do
			table.insert(output, v)
		end
	end
	if Json2 ~= nil then
		for _, v in ipairs(Json2) do
			table.insert(output, v)
		end
	end
	return output
end

local function jsonText(json)
	if type(json) == "string" then
		return json
	else
		local out = ""
		for _, v in ipairs(json) do
			out = out .. (v.text or "")
		end
		return out
	end
end

function events.tick()
	if textname == nil or textname == "" then
		textname = player:getName()
	end
	name = { text = textname, color = nameCol }
	-- rainbow --
	if getnum("actionToggles", "namerainbow") then
		name = rainbowName(textname, false, getnum("actionToggles", "namerainbowmove"))
	end
	-- afk --
	if getnum("actionToggles", "afk") then
		at = at + 1
		name = JsonMerge({ name }, { { text = "[AFK:" .. math.floor(at / 20) .. "]", color = "#FF0000" } })
	else
		at = 0
	end
	-- set --
	np.setname(JsonMerge({ name }, { { text = accessory, color = "#FFFFFF" } }))
	t = t + 1
end
