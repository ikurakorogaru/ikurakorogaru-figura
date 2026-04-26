local t = 0
local ht = 0
local at = 0
local nextBlink = 0
local name = ""
local lastNameJson = nil
local Managers = {}
-- imports --
Managers = require("./manager/imports")


-- patpat --
local pp = {}
-- actionwheels --
local aw = {}
aw.newToggleAction = Managers.actionwheel.newToggleAction
aw.setActionColor = Managers.actionwheel.setActionColor
aw.newActionPage = Managers.actionwheel.newActionPage
aw.newNumAction = Managers.actionwheel.newNumAction
aw.newAction = Managers.actionwheel.newAction
aw.getnum = Managers.actionwheel.getnum
aw.setnum = Managers.actionwheel.setnum
aw.openPage = Managers.actionwheel.openPage
-- eyesequence --
local es = {}
es.newSequence = Managers.eyesequence.newSequence



function events.entity_init()
	name = player:getName()
	local nowName = {
		text = name,
		color = "#FFFFFF"
	}
end

vanilla_model.ARMOR:setVisible(false)


vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
local headParts = { models.model.root.Head.Head1, models.model.root.Head.Head2, models.model.root.Head.Head3,
	models.model.root.Head.Head4, models.model.root.Head.eye_up, models.model.root.Head.eye_down }



function pings.changeToggles(name, Bool)
	aw.setnum("actionToggles", name, Bool)

	if aw.getnum("actions", name) ~= nil then
		aw.getnum("actions", name):setToggled(Bool)
	end
end

function pings.changeNums(name, num)
	aw.setnum("actionNums", name, num)
end

vanilla_model.ARMOR:setVisible(false)



function blink()
	es.newSequence({
		["ru"] = false, ["lu"] = false, ["rd"] = true, ["ld"] = true, ["tick"] = t
	})
	es.newSequence({
		["ru"] = false, ["lu"] = false, ["rd"] = false, ["ld"] = false, ["tick"] = t + 1
	})
	es.newSequence({
		["ru"] = false, ["lu"] = false, ["rd"] = true, ["ld"] = true, ["tick"] = t + 5
	})
	es.newSequence({
		["ru"] = true, ["lu"] = true, ["rd"] = true, ["ld"] = true, ["tick"] = t + 6
	})
end

function pings.blink()
	blink()
end

function pings.lwink()
	es.newSequence({
		["lu"] = false,
		["ld"] = true,
		["tick"] = t
	})
	es.newSequence({
		["lu"] = false,
		["ld"] = false,
		["tick"] = t + 1
	})
	es.newSequence({
		["lu"] = false,
		["ld"] = true,
		["tick"] = t + 16
	})
	es.newSequence({
		["lu"] = true,
		["ld"] = true,
		["tick"] = t + 17
	})
end

function pings.rwink()
	es.newSequence({
		["ru"] = false,
		["rd"] = true,
		["tick"] = t
	})
	es.newSequence({
		["ru"] = false,
		["rd"] = false,
		["tick"] = t + 1
	})
	es.newSequence({
		["ru"] = false,
		["rd"] = true,
		["tick"] = t + 16
	})
	es.newSequence({
		["ru"] = true,
		["rd"] = true,
		["tick"] = t + 17
	})
end

-- ai --

-- HSV to HEX --
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
	if aw.getnum("actionToggles", "namerainbow") then
		for i = 1, #text do
			local col
			local myText = string.sub(text, i, i)
			if aw.getnum("actionToggles", "namerainbowmove") then
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

local function setname(text)
	local j = toJson(text)
	if j ~= lastNameJson then
		nameplate.ALL:setText(j)
		lastNameJson = j
	end
end

function pings.changeName(iname)
	name = iname
end

function events.tick()
	-- afk --
	if aw.getnum("actionToggles", "afk") then
		at = at + 1
		setname(JsonMerge(rainbowName("#FFFFFF", false, name), ({ {
			text = "[AFK:" .. math.floor(at / 20) .. "]",
			color = "#FF0000"
		} })))
	else
		at = 0
		setname(rainbowName("#FFFFFF", false, name))
	end
	-- autoBlink --
	if aw.getnum("actionToggles", "autoBlink") then
		if nextBlink == 0 then
			blink()
			nextBlink = math.random(80, 160)
		else
			nextBlink = nextBlink - 1
		end
	end
	-- toggles --
	-- head
	if aw.getnum("actionToggles", "head") then
		ht = ht + aw.getnum("actionNums", "headSpeedChange")
		-- headSpeed
		if aw.getnum("actionToggles", "headSpeed") then
			local v = player:getVelocity()
			ht = ht + (math.abs(v.x * 2) + math.abs(v.z * 2))
		end
	else
		ht = 0
	end
	for i, part in ipairs(headParts) do
		part:setOffsetRot(0, ht * (i % 2 * 2 - 1), 0)
	end
	-- armor

	-- models.model.root:setOffsetRot(t^2)
	-- others --
	t = t + 1
end
