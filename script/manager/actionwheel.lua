local actionwheelmanager = require("./imports").actionwheel
local aw = {}
aw.newToggleAction = actionwheelmanager.newToggleAction
aw.setActionColor = actionwheelmanager.setActionColor
aw.newActionPage = actionwheelmanager.newActionPage
aw.newNumAction = actionwheelmanager.newNumAction
aw.newAction = actionwheelmanager.newAction
aw.getnum = actionwheelmanager.getnum
aw.setnum = actionwheelmanager.setnum
aw.openPage = actionwheelmanager.openPage



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


------------------------------------------------------------------- functions -------------------------------------------------------------------

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
	reloadActions("head")
end

------------------------------------------------------------------- \functions -------------------------------------------------------------------
reloadActions(nil)
