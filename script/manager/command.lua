




function events.chat_send_message(msg)
	if msg:sub(1, 6) == ";model" and (msg:sub(7, 7) == "" or msg:sub(7, 7) == " ") then
		local args = {}
		msg = msg:sub(8)
		for word in msg:gmatch("%S+") do
			table.insert(args, word)
		end
		-- name --
		if args[1] == "name" then
			if args[2] == "set" then
				pings.changeName(string.sub(args[3], 1, 64))
			end
			if args[2] == "reset" then
				pings.changeName(player:getName())
			end
		end
		-- skull --
		if args[1] == "skull" then
			if args[2] == "speed" then
				if args[3] == "set" then
					pings.changeSkullSpeed(tonumber(args[4]))
				end
				if args[3] == "reset" then
					pings.changeSkullSpeed(1)
				end
			end
		end
		-- color --
		if args[1] == "color" then
			if args[2] == "set" and args[3] ~= nil and args[4] ~= nil and args[5] ~= nil then
				avatar:setColor(args[3] / 255, args[4] / 255, args[5] / 255)
			end
			if args[2] == "now" then
				print(avatar:getColor())
			end
			if args[2] == "reset" then
				avatar:setColor(102 / 255, 117 / 255, 52 / 255)
			end
		end

		------------
		return nil
	else
		return msg
	end
end