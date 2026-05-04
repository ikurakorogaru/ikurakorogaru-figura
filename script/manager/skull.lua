local st = 0
local headParts_s = { models.model.Skull.Head1, models.model.Skull.Head2, models.model.Skull.Head3,
    models.model.Skull.Head4, models.model.Skull.eye_up_s, models.model.Skull.eye_down_s }
function events.SKULL_RENDER(delta, block, item, entity, mode)
    for i, part in ipairs(headParts_s) do
        if mode ~= "BLOCK" or block:getProperties().powered == "true" then
            part:setOffsetRot(0,
                (i % 2 * 2 - 1) *
                (st + require("script.library.internal.actionwheel").getNumById("root_skull", "skullSpeedChange") * delta),
                0)
        else
            part:setOffsetRot(0, 0, 0)
        end
    end
end

require("script.manager.imports").l.tickmanager.setScheduler("skull", function()
    st = st + require("script.library.internal.actionwheel").getNumById("root_skull", "skullSpeedChange")
end)

function pings.changeSkullSpeed(n)
    if type(n) == "number" then
        skullSpeed = n
    end
end
