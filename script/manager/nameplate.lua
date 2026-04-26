local manager = require("./imports")
local getnum = manager.actionwheel.getnum
local np = {}
np.setname = manager.nameplate.setname
np.addname = manager.nameplate.addname
np.nowname = manager.nameplate.nowname
local at = 0
local name = {}

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

	-- RGBを0-255に変換して16進数文字列にする
	return string.format("#%02X%02X%02X", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255))
end

-- name.rainbow --
local function rainbowName(defaultCol, rainbowColorInversion, text)
	local nameText = {}
	if getnum("actionToggles", "namerainbow") then
		for i = 1, #text do
			local col
			local myText = string.sub(text, i, i)
			if getnum("actionToggles", "namerainbowmove") then
				if rainbowColorInversion then
					col = hsvToHex((((i + 0 - t / 10) + 0.5) % 1) / #text, 0.5, 1)
				else
					col = hsvToHex((i + 0 - t / 10) / #text, 0.5, 1)
				end
			else
				col = hsvToHex(i / #text, 0.5, 1)
			end
			table.insert(nameText, {
				text = myText,
				color = col
			})
		end
		return nameText
	else
		return { {
			text = text,
			color = defaultCol
		} }
	end
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

function events.tick()
	name = { text = player:getName(), color = "#667534" }
	-- afk --
	if getnum("actionToggles", "afk") then
		at = at + 1
		name = JsonMerge({ name }, { { text = "[AFK:" .. math.floor(at / 20) .. "]", color = "#FF0000" } })
	else
		at = 0
	end
	-- set --
	np.setname(name)
end