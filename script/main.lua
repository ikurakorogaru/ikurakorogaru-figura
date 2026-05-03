local tryto, msg = pcall(require, "script.manager.managers")
if msg and #msg ~= 0 then
    print("§cERROR :")
    for _, e in ipairs(msg) do
        print("§c" .. e.name .. "§r")
        print(e.msg)
    end
end
