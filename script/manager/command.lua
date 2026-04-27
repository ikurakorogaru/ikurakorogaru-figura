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
				pings.changeName("")
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
		------------
		return nil
	else
		return msg
	end
end

function pings.changeFiguraCol(r, g, b)
	avatar:setColor(r / 255, g / 255, b / 255)
end
