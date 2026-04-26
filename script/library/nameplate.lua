-- TODO: 完成/バグ修正
-- set/add nameがバグってる
local np = {}
local nums = {}
nums.nowname = {
	CHAT = "",
	ENTITY = "",
	LIST = ""
}

function np.getnum(g, k)
	if k ~= nil then
		return nums[g][k]
	else
		return nums[g]
	end
end

function np.setnum(g, k, v)
	if nums[g] == nil then
		nums[g] = {}
	end
	if k ~= nil then
		nums[g][k] = v
	else
		nums[g] = v
	end
end

function np.setname(t, plateType)
	if t ~= nil then
		if plateType == nil then
			for k, v in pairs(nums.nowname) do
				nameplate[k]:setText(t)
				nums.nowname[k] = t
			end
		else
			nameplate[plateType]:setText(t)
			nums.nowname[plateType] = t
		end
	end
end

function np.addname(t, plateType, pos)
	if t ~= nil then
		if plateType == nil then
			for k, v in pairs(nums.nowname) do
				if pos == true then nameplate[k]:setText(v .. t) end
				if pos == false then nameplate[k]:setText(t .. v) end
			end
		else
			if pos == true then nameplate[plateType]:setText(nums.nowname[plateType] .. t) end
			if pos == false then nameplate[plateType]:setText(t .. nums.nowname[plateType]) end
		end
	end
	nums.nowname[plateType] = t
end

function np.nowname(type)

end
