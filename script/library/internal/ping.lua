local p = {}
local nums = {}
local update_pending = {}
local update_order = {}
local handlers = {}
local defaults = {}
local full_sync_interval = 600
local t = 0
local send_limit = 16
local full_sync_index = 1
local full_sync_keys = {}
local full_sync_running = false
local last_second = -1
local sent_this_second = 0

function p.setdefault(name, num)
    if defaults[name] == nil then
        defaults[name] = num
    end

    if nums[name] == nil then
        nums[name] = num
    end
end

function p.setnum(name, num, update_type)
    if num == nil then
        nums[name] = nil
        defaults[name] = nil
        update_pending[name] = nil
        return
    end

    if nums[name] == num then
        return
    end

    nums[name] = num

    if update_type then
        pings.innums(name, num)
    else
        if update_pending[name] == nil then
            update_order[#update_order + 1] = name
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

require("script.library.internal.tickmanager").setScheduler("library-ping", function()
    local current_second = math.floor(t / 20)

    if current_second ~= last_second then
        sent_this_second = 0
        last_second = current_second
    end

    while #update_order > 0 and sent_this_second < send_limit do
        local name = table.remove(update_order, 1)
        local num = update_pending[name]

        if num ~= nil then
            pings.innums(name, num)
            update_pending[name] = nil
            sent_this_second = sent_this_second + 1
        end
    end

    if t % full_sync_interval == 0 then
        full_sync_keys = {}

        for name, value in pairs(nums) do
            if value ~= nil and value ~= defaults[name] then
                full_sync_keys[#full_sync_keys + 1] = name
            end
        end

        table.sort(full_sync_keys)
        full_sync_index = 1
        full_sync_running = true
    end

    if full_sync_running and sent_this_second < send_limit then
        while full_sync_index <= #full_sync_keys and sent_this_second < send_limit do
            local name = full_sync_keys[full_sync_index]

            if nums[name] ~= nil and nums[name] ~= defaults[name] then
                pings.innums(name, nums[name])
                sent_this_second = sent_this_second + 1
            end

            full_sync_index = full_sync_index + 1
        end

        if full_sync_index > #full_sync_keys then
            full_sync_running = false
            full_sync_index = 1
        end
    end

    t = t + 1
end)

return p
