local p = {}
local nums = {}
local update_pending = {}
local t = 0
local send_limit = 16

function p.setnum(name, num, update_type)
	if update_type then
		pings.innums(name, num)
		nums[name] = num
	end
	if not update_type then
		p.inpending(name, num)
		nums[name] = num
	end
end

function p.getnum(name)
	return nums[name]
end

function p.inpending(name, num)
	update_pending[name] = num
end

function pings.innums(name, num)
	nums[name] = num
end

function events.tick()
	if t % 20 == 0 then
		local sent = 0

		for name, num in pairs(update_pending) do
			pings.innums(name, num)
			update_pending[name] = nil

			sent = sent + 1
			if sent >= send_limit then break end
		end
	end

	t = t + 1
end

return p
