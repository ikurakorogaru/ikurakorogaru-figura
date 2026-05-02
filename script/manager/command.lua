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
        if args[1] == "accessory" then
            if args[2] == "set" then
                pings.setAccessory(args[3])
            end
            if args[2] == "reset" then
                pings.setAccessory("")
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
