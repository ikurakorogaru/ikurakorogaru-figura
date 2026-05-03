local pls = {
    "script.manager.imports",
    "script.manager.actionwheel",
    "script.manager.actionTick",
    "script.manager.command",
    "script.manager.skull",
    "script.manager.nameplate",
    "script.manager.setup",
    "script.manager.tests",
}
local errors = {}
for k, v in ipairs(pls) do
    local tryto, msg = pcall(require, v)
    if not tryto then
        errors[#errors + 1] = { name = v, msg = msg }
    end
end
return errors
