local p = {}
local nums = {}
local update_pending = {}
local update_order = {}
local handlers = {}
local t = 0
local send_limit = 16
local full_sync_interval = 600
local full_sync_index = 1

function p.setnum(name, num, update_type)
    nums[name] = num

    if update_type then
        pings.innums(name, num)
    else
        if update_pending[name] == nil then
            table.insert(update_order, name)
        end

        update_pending[name] = num
    end
end

function p.getnum(name)
    return nums[name]
end

function p.on(prefix, fn)
    handlers[prefix] = fn
end

function pings.innums(name, num)
    nums[name] = num

    for prefix, fn in pairs(handlers) do
        if name:sub(1, #prefix) == prefix then
            fn(name, num)
        end
    end
end

function events.tick()
    local current_second = math.floor(t / 20)

    if current_second ~= last_second then
        sent_this_second = 0
        last_second = current_second
    end

    local sent = 0

    -- 通常更新
    if t % 1 == 0 then
        while #update_order > 0 and sent_this_second < 16 do
            local name = table.remove(update_order, 1)
            local num = update_pending[name]

            if num ~= nil then
                pings.innums(name, num)
                update_pending[name] = nil
                sent_this_second = sent_this_second + 1
            end
        end
    end

    -- full sync（余った枠だけ使う）
    if sent_this_second < 16 then
        local keys = {}

        for name, _ in pairs(nums) do
            table.insert(keys, name)
        end

        table.sort(keys)

        while full_sync_index <= #keys and sent_this_second < 16 do
            local name = keys[full_sync_index]
            pings.innums(name, nums[name])

            full_sync_index = full_sync_index + 1
            sent_this_second = sent_this_second + 1
        end

        if full_sync_index > #keys then
            full_sync_index = 1
        end
    end

    t = t + 1
end

return p
