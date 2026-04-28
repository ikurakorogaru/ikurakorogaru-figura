local manager = require("script.manager.imports")
local aw = {}
aw.getnum = manager.actionwheel.getnum
local es = {}
es.newSequence = manager.eyesequence.newSequence
-- -- -- -- --
local t = 0
local ht = 0
local nextBlink = 0
---------------------------------------------------------------
local function blink()
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
---------------------------------------------------------------
local headParts = { models.model.root.Head.Head1, models.model.root.Head.Head2, models.model.root.Head.Head3,
	models.model.root.Head.Head4, models.model.root.Head.eye_up, models.model.root.Head.eye_down }

function events.tick()
		-- autoBlink --
	if aw.getnum("actionToggles", "autoBlink") then
		if nextBlink == 0 then
			pings.blink()
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