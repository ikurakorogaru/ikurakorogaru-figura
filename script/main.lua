local t = 0
local ht = 0
local st = 0
local at = 0
local nextBlink = 0
local blinkSequence = {}
local skullSpeed = 0.5
local name = ""
local lastNameJson = nil
local Managers = {}
-- imports --
Managers.patpat = require("./library/patpat")
Managers.actionwheel = require("./library/actionwheel")
Managers.eyesequence = require("./library/eyesequence")


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

local function reloadActions(openpage)
	aw.setnum("actions", nil, {})
	aw.setnum("pages", nil, {})
	aw.setnum("pages", "root", action_wheel:newPage())
	local pages = aw.getnum("pages", nil)
	aw.newActionPage(pages.root, "head", "heads", "minecraft:player_head", 255, 245, 169, true)
	aw.newToggleAction(pages.head, "head", "headToggle", "minecraft:lever", true, 255, 245, 169, true)
	aw.newNumAction(pages.head, "headSpeedChange", "headSpeedChange", "minecraft:lever", 1, 255, 245, 169,
		true)
	aw.newAction(pages.head, "headSpeedReset", "headSpeedReset", "minecraft:barrier", pings.speedReset,
		nil,
		255, 245, 169, true)
	aw.newToggleAction(pages.head, "headSpeed", "headSpeedToggle", "minecraft:lever", true, 255, 245, 169, true)
	aw.newAction(pages.head, "blink", "blink", "minecraft:oak_button", pings.blink, nil, 255, 245, 169, true)
	aw.newAction(pages.head, "wink", "wink", "minecraft:oak_button", pings.lwink, pings.rwink, 255, 245, 169, true)
	aw.newToggleAction(pages.head, "autoBlink", "autoBlinkToggle", "minecraft:lever", true, 255, 245, 169, true)

	aw.newActionPage(pages.root, "name", "names", "minecraft:name_tag", 33, 33, 33, true)
	aw.newToggleAction(pages.name, "namerainbow", "nametagToggle", "minecraft:lever", false, 255, 245, 169, true)
	aw.newToggleAction(pages.name, "namerainbowmove", "nametagMove", "minecraft:lever", false, 255, 245, 169, true)
	aw.newToggleAction(pages.name, "afk", "afkToggle", "minecraft:barrier", false, 255, 0, 0, true)

	aw.newActionPage(pages.root, "animation", "animations", "minecraft:observer", 91, 125, 66, true)
	aw.newAction(pages.animation, "animation_1", "animation 1", "minecraft:oak_button", pings.animation_1, nil, 42, 42, 42,
		true)

	aw.newActionPage(pages.root, "other", "others", "minecraft:slime_block", 0, 192, 0, true)
	aw.newAction(pages.other, "effect", "effect", "minecraft:oak_button", pings.effect, nil, 255, 245, 169, true)
	aw.newAction(pages.other, "armorvisible", "armorvisible", "minecraft:oak_button", pings.avisible, pings.aunvisible,
		255, 245, 169, true)
	aw.newActionPage(pages.root, "test", "tests", "minecraft:command_block", 0, 0, 0, true)
	aw.newActionPage(pages.test, "test_test", "tests", "minecraft:command_block", 0, 0, 0, true)
	if openpage ~= nil then
		aw.openPage(openpage)
	else
		aw.openPage("root")
	end
end

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
local headParts_s = { models.model.Skull.Head1, models.model.Skull.Head2, models.model.Skull.Head3,
	models.model.Skull.Head4, models.model.Skull.eye_up_s, models.model.Skull.eye_down_s }


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

function pings.animation_1()
	animations.model.test1:play()
end

function pings.effect()
	local speed = 0.25
	for _ = 1, 50 do
		local myParticle = particles["end_rod"]
		myParticle:setPos(player:getPos() + vectors.vec3(0, 1, 0))
		myParticle:setVelocity(math.random(-speed * 100, speed * 100) / 100,
			math.random(-speed * 100, speed * 100) / 100, math.random(-speed * 100, speed * 100) / 100)
		myParticle:spawn()
	end
end

function pings.avisible()
	vanilla_model.ARMOR:setVisible(true)
end

function pings.aunvisible()
	vanilla_model.ARMOR:setVisible(false)
end

function pings.speedReset()
	aw.setnum("actionNums", "headSpeedChange", 1)
	reloadActions("heads")
end

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

reloadActions(nil)

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

function pings.changeSkullSpeed(n)
	if type(n) == "number" then
		skullSpeed = n
	end
end

-- commands --
function events.chat_send_message(msg)
	if msg:sub(1, 6) == ";model" and (msg:sub(7, 7) == "" or msg:sub(7, 7) == " ") then
		local args = {}
		msg = msg:sub(8)
		for word in msg:gmatch("%S+") do
			table.insert(args, word)
		end
		-- name --
		if args[1] == "name" then
			if args[2] == "set" then
				pings.changeName(string.sub(args[3], 1, 64))
			end
			if args[2] == "reset" then
				pings.changeName(player:getName())
			end
		end
		-- skull --
		if args[1] == "skull" then
			if args[2] == "speed" then
				if args[3] == "set" then
					pings.changeSkullSpeed(tonumber(args[4]))
				end
				if args[3] == "reset" then
					pings.changeSkullSpeed(1)
				end
			end
		end
		-- color --
		if args[1] == "color" then
			if args[2] == "set" and args[3] ~= nil and args[4] ~= nil and args[5] ~= nil then
				avatar:setColor(args[3] / 255, args[4] / 255, args[5] / 255)
			end
			if args[2] == "now" then
				print(avatar:getColor())
			end
			if args[2] == "reset" then
				avatar:setColor(102 / 255, 117 / 255, 52 / 255)
			end
		end

		------------
		return nil
	else
		return msg
	end
end

function events.SKULL_RENDER(delta, block, item, entity, mode)
	for i, part in ipairs(headParts_s) do
		if mode ~= "BLOCK" or block:getProperties().powered == "true" then
			part:setOffsetRot(0, (i % 2 * 2 - 1) * (st + skullSpeed * delta), 0)
		else
			part:setOffsetRot(0, 0, 0)
		end
	end
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
	st = st + skullSpeed
end
