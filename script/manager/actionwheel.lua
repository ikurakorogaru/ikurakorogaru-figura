local manager = require("./imports")
local aw = {}
local es = {}
aw.newToggleAction = manager.l.actionwheel.newToggleAction
aw.setActionColor = manager.l.actionwheel.setActionColor
aw.newActionPage = manager.l.actionwheel.newActionPage
aw.newNumAction = manager.l.actionwheel.newNumAction
aw.newAction = manager.l.actionwheel.newAction
aw.getnum = manager.l.actionwheel.getnum
aw.setnum = manager.l.actionwheel.setnum
aw.openPage = manager.l.actionwheel.openPage
aw.delall = manager.l.actionwheel.delall
es.delall = manager.l.eyesequence.delall
local funs = {}

local function reloadActions(openpage)
	aw.setnum("actions", nil, {})
	aw.setnum("pages", nil, {})
	aw.setnum("pages", "root", action_wheel:newPage())
	local pages = aw.getnum("pages", nil)
	--head
	aw.newActionPage(pages.root, "head", "heads", "minecraft:player_head", 255, 245, 169, true)
	--head\rotate
	aw.newActionPage(pages.head, "rotate", "rotates", "minecraft:lever", 128, 128, 128, true)
	aw.newToggleAction(pages.rotate, "head", "headToggle", "minecraft:lever", true, 255, 245, 169, true)
	aw.newNumAction(pages.rotate, "headSpeedChange", "headSpeedChange", "minecraft:lever", 1, 255, 245, 169,
		true)
	aw.newAction(pages.rotate, "headSpeedReset", "headSpeedReset", "minecraft:barrier", pings.speedReset,
		nil,
		255, 245, 169, true)
	aw.newToggleAction(pages.rotate, "headSpeed", "headSpeedToggle", "minecraft:lever", true, 255, 245, 169, true)
	--head\eye
	aw.newActionPage(pages.head, "eye", "eyes", "minecraft:ender_eye", 0, 89, 36, true)
	aw.newAction(pages.eye, "blink", "blink", "minecraft:oak_button", pings.blink, nil, 255, 245, 169, true)
	aw.newAction(pages.eye, "wink", "wink", "minecraft:oak_button", pings.lwink, pings.rwink, 255, 245, 169, true)
	aw.newToggleAction(pages.eye, "autoBlink", "autoBlinkToggle", "minecraft:lever", true, 255, 245, 169, true)
	--name
	aw.newActionPage(pages.root, "name", "names", "minecraft:name_tag", 33, 33, 33, true)
	aw.newToggleAction(pages.name, "namerainbow", "nametagToggle", "minecraft:lever", false, 255, 245, 169, true)
	aw.newToggleAction(pages.name, "namerainbowmove", "nametagMove", "minecraft:lever", false, 255, 245, 169, true)
	aw.newToggleAction(pages.name, "afk", "afkToggle", "minecraft:barrier", false, 255, 0, 0, true)
	--animation
	aw.newActionPage(pages.root, "animation", "animations", "minecraft:observer", 91, 125, 66, true)
	aw.newAction(pages.animation, "animation_1", "animation 1", "minecraft:oak_button", pings.animation_1, nil, 42, 42, 42,
		true)
	--other
	aw.newActionPage(pages.root, "other", "others", "minecraft:slime_block", 0, 192, 0, true)
	aw.newAction(pages.other, "effect", "effect", "minecraft:oak_button", pings.effect, nil, 255, 245, 169, true)
	aw.newAction(pages.other, "armorvisible", "armorvisible", "minecraft:oak_button", pings.avisible, pings.aunvisible,
		255, 245, 169, true)
	aw.newAction(pages.other, "reload", "reload", "minecraft:barrier", pings.reLoad, nil, 255, 0, 0, true)
	--debug
	aw.newActionPage(pages.root, "debug", "debug", "minecraft:command_block", 0, 0, 0, true)
	aw.newAction(pages.debug, "memorys", "memorys", "minecraft:green_stained_glass", funs.memorys, nil, 255, 0, 255, true)
	if openpage ~= nil then
		aw.openPage(openpage)
	else
		aw.openPage("root")
	end
end


------------------------------------------------------------------- functions -------------------------------------------------------------------

function pings.reLoad()
	aw.delall()
	reloadActions(nil)
	pings.setAccessory("")
	pings.changeName(player:getName())
	es.delall()
end

function funs.memorys()
	print("----- memory dump -----")
	print("paths: " .. table.concat(aw.getnum("paths"), "/"))

	print("toggles:")
	for k, v in pairs(aw.getnum("actionToggles")) do
		print("  " .. k .. " = " .. tostring(v))
	end

	print("numbers:")
	for k, v in pairs(aw.getnum("actionNums")) do
		print("  " .. k .. " = " .. tostring(v))
	end
end

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
	aw.setnum("actionNums", "headSpeedChange", 1, true)
	reloadActions("rotate")
end

------------------------------------------------------------------- \functions -------------------------------------------------------------------
reloadActions(nil)
