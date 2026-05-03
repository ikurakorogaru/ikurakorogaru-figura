local es = {}
local nums = {}
local t = 0

function es.getnum(g, k)
    if k ~= nil then
        return nums[g][k]
    else
        return nums[g]
    end
end

function es.setnum(g, k, v)
    if nums[g] == nil then
        nums[g] = {}
    end
    if k ~= nil then
        nums[g][k] = v
    else
        nums[g] = v
    end
end

es.setnum("blinkSequences", nil, {})

local types = {
    ["ru"] = models.model.root.Head.eye_up.ur,
    ["rd"] = models.model.root.Head.eye_down.dr,
    ["lu"] = models.model.root.Head.eye_up.ul,
    ["ld"] = models.model.root.Head.eye_down.dl
}



function es.newSequence(input)
    table.insert(nums.blinkSequences, input)
end

function es.blinkSequence(t)
    for i = #nums.blinkSequences, 1, -1 do
        local mySequence = nums.blinkSequences[i]
        if mySequence.tick == t then
            for k, v in pairs(mySequence) do
                if k ~= "tick" then
                    types[k]:setVisible(v)
                end
            end
            table.remove(nums.blinkSequences, i)
        end
    end
end

function es.delall()
    es.setnum("blinkSequences", nil, {})
end

require("script.library.internal.tickmanager").setScheduler("library-eyesequence", function()
    es.blinkSequence(t)
    t = t + 1
end)

return es
