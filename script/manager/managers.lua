local pls = {
    "script.manager.imports",
    "script.manager.actionwheel",
    "script.manager.actionTick",
    "script.manager.command",
    "script.manager.skull",
    "script.manager.nameplate",
    "script.manager.setup",
}

for k, v in ipairs(pls) do
    local tryto, msg = pcall(require, v)
    if not tryto then
        print(v .. ": §cERROR! : §r" .. msg)
    end
end
