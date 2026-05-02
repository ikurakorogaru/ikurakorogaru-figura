local tryto, msg = pcall(require, "script.manager.managers")
if not tryto then
    print("§cERROR DOWN :")
    print(msg)
end
