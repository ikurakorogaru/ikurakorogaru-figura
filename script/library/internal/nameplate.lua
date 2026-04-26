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
				local newName = v

				if pos == false then
					newName = t .. v
				else
					newName = v .. t
				end

				nameplate[k]:setText(newName)
				nums.nowname[k] = newName
			end
		else
			local v = nums.nowname[plateType]
			local newName = v

			if pos == false then
				newName = t .. v
			else
				newName = v .. t
			end

			nameplate[plateType]:setText(newName)
			nums.nowname[plateType] = newName
		end
	end
end

function np.nowname(plateType)
	if plateType ~= nil then
		if nums.nowname[plateType] ~= nil then
			return nums.nowname[plateType]
		else
			return nil
		end
	else
		return nums.nowname
	end
end
