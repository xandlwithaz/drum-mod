net.Receive("barrelMessage", function()
    local message = net.ReadString()
    local hasCount = net.ReadBool()
    if hasCount then
        local count = net.ReadInt(32)
        chat.AddText(Color(183, 223, 173), message, Color(255, 85, 85), tostring(count))
    else
        chat.AddText(Color(183, 223, 173), message)
    end
end)

--[[
@xandlwithaz
https://github.com/xandlwithaz/drum-mod
https://steamcommunity.com/sharedfiles/filedetails/?id=3818711180
]]