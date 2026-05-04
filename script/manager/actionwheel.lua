local manager = require("./imports")
local aw = manager.l.actionwheel
local es = {}



es.delall = manager.l.eyesequence.delall

local funs = {}

local function reloadActions(openpage)
    aw.setnum("actions", nil, {})
    aw.setnum("pages", nil, {})
    local root = action_wheel:newPage()
    aw.setRootPage(root)

    -- head
    local head = aw.newActionPage(root, "head", "heads", "minecraft:player_head", 255, 245, 169, true)

    -- head/rotate
    local rotate = aw.newActionPage(head, "rotate", "rotates", "minecraft:lever", 128, 128, 128, true)
    aw.newToggleAction(rotate, "head", "headToggle", "minecraft:lever", true, 255, 245, 169, true)
    aw.newNumAction(rotate, "headSpeedChange", "headSpeedChange", "minecraft:lever", 1, 255, 245, 169, true)
    aw.newAction(rotate, "headSpeedReset", "headSpeedReset", "minecraft:barrier", function()
        print("before ping call")
        pings.headSpeedReset()
        print("after ping call")
    end, nil, 255, 245, 169, true)
    aw.newToggleAction(rotate, "headSpeed", "headSpeedToggle", "minecraft:lever", true, 255, 245, 169, true)

    -- head/eye
    local eye = aw.newActionPage(head, "eye", "eyes", "minecraft:ender_eye", 0, 89, 36, true)
    aw.newAction(eye, "blink", "blink", "minecraft:oak_button", pings.blink, nil, 255, 245, 169, true)
    aw.newAction(eye, "wink", "wink", "minecraft:oak_button", pings.lwink, pings.rwink, 255, 245, 169, true)
    aw.newToggleAction(eye, "autoBlink", "autoBlinkToggle", "minecraft:lever", true, 255, 245, 169, true)

    -- skull
    local skull = aw.newActionPage(root, "skull", "skulls", "minecraft:observer", 255, 245, 169, true)
    aw.newNumAction(skull, "skullSpeedChange", "skullSpeedChange", "minecraft:lever", 1, 255, 245, 169, true)
    aw.newAction(skull, "skulldSpeedReset", "skullSpeedReset", "minecraft:barrier",
        (function() pings.skullSpeedReset() end),
        nil, 255, 245,
        169, true)

    -- name
    local name = aw.newActionPage(root, "name", "names", "minecraft:name_tag", 33, 33, 33, true)
    aw.newToggleAction(name, "namerainbow", "nametagToggle", "minecraft:lever", false, 255, 245, 169, true)
    aw.newToggleAction(name, "namerainbowmove", "nametagMove", "minecraft:lever", false, 255, 245, 169, true)
    aw.newToggleAction(name, "afk", "afkToggle", "minecraft:barrier", false, 255, 0, 0, true)

    -- animation
    local animation = aw.newActionPage(root, "animation", "animations", "minecraft:observer", 91, 125, 66, true)
    aw.newAction(animation, "animation_1", "animation 1", "minecraft:oak_button", pings.animation_1, nil, 42, 42, 42,
        true)

    -- other
    local other = aw.newActionPage(root, "other", "others", "minecraft:slime_block", 0, 192, 0, true)
    aw.newAction(other, "effect", "effect", "minecraft:oak_button", pings.effect, nil, 255, 245, 169, true)
    aw.newAction(other, "armorvisible", "armorvisible", "minecraft:oak_button", pings.avisible, pings.aunvisible, 255,
        245, 169, true)

    -- debug
    local debug = aw.newActionPage(root, "debug", "debug", "minecraft:command_block", 0, 0, 0, true)
    aw.newAction(debug, "memorys", "memorys", "minecraft:green_stained_glass", funs.memorys, nil, 255, 0, 255, true)
    aw.newAction(debug, "reload", "reload", "minecraft:barrier", pings.reLoad, nil, 255, 0, 0, true)

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
    print("paths: " .. table.concat(aw.getnum("paths"), "_"))

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

function pings.headSpeedReset()
    aw.setNumById("root_head_rotate", "headSpeedChange", 1, true)
    reloadActions("root_head_rotate")
end

function pings.skullSpeedReset()
    aw.setnum("actionNums", "root_skull:skullSpeedChange", 1, nil)
    reloadActions("root_skull")
end

------------------------------------------------------------------- \functions -------------------------------------------------------------------



reloadActions(nil)
