net.Receive("barrelMessage", function()
    local message = net.ReadString()
    local hasCount = net.ReadBool()
    if hasCount then
        local count = net.ReadInt(32)
        chat.AddText(Color(255, 255, 255), message, Color(255, 85, 85), tostring(count))
    else
        chat.AddText(Color(255, 255, 255), message)
    end
end)

--[[

clientsided bullshit!!!!!!!!!!!!!!!!!
@xandlwithaz

]]