local manager = require("./imports")
local aw = manager.actionwheel
function pings.changeToggles(name, Bool)
	aw.setnum("actionToggles", name, Bool)

	if aw.getnum("actions", name) ~= nil then
		aw.getnum("actions", name):setToggled(Bool)
	end
end

function pings.changeNums(name, num)
	aw.setnum("actionNums", name, num)
end