local tm = {}
local schedulers = {}
local errorstopped = {}

function tm.setScheduler(t, f)
    schedulers[t] = f
    errorstopped[t] = false
end

function events.tick()
    for k, fn in pairs(schedulers) do
        if not errorstopped[k] then
            local ok, msg = pcall(fn)

            if not ok then
                errorstopped[k] = true
                print("§cTICK ERROR : " .. k)
                print(msg)
            end
        end
    end
end

return tm
