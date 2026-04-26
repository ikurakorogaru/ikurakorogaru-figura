local t = 0
local ht = 0
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
	-- others --
	t = t + 1
end
