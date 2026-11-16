local barrel = 1
util.AddNetworkString("barrelMessage")

local function sendBarrelMessage(ply, message, count)
    net.Start("barrelMessage")
    net.WriteString(message)
    net.WriteBool(count ~= nil)
    if count ~= nil then
        net.WriteInt(count, 32)
    end
    net.Send(ply)
end

local function barrelSwitch(ply)
    if ply:IsAdmin() then
        if barrel == 1 then
            barrel = 0
            ply:ChatPrint("drums are now disabled;")
        else
            barrel = 1
            ply:ChatPrint("drums are now enabled;")
        end
    else
        sendBarrelMessage(ply, "sorry! to use this command, you must either be an admin or superadmin!")
    end
end

local function spawnBarrel(ply)
    if barrel == 1 then
        print("spawning drum for " .. ply:Nick())
        local prop = ents.Create("prop_physics")
        local model
        local sound
        if math.random(1, 17) == 1 then -- 5.8% chance
            model = "models/props_borealis/bluebarrel001.mdl"
            sound = "physics/plastic/plastic_barrel_impact_hard1.wav"
        elseif math.random(1, 27) == 1 then -- 3.7% chance if the bluebarrel001 fails(3.5% overall chance)
            model = "models/props_c17/oildrum001_explosive.mdl"
            sound = "ambient/explosions/explode_1.wav"
        else
            model = "models/props_c17/oildrum001.mdl"
            sound = "physics/metal/metal_barrel_impact_hard1.wav"
        end
        ---@diagnostic disable-next-line: inject-field
        prop.owner = ply:SteamID64()
        prop:SetModel(model)
        if model == "models/props_borealis/bluebarrel001.mdl" then
            prop:SetPos(ply:GetEyeTrace().HitPos + Vector(0, 0, 40))
        else
            prop:SetPos(ply:GetEyeTrace().HitPos + Vector(0, 0, 15))
        end
        prop:Spawn()
        prop:EmitSound(sound)
    else
        sendBarrelMessage(ply, "drums are disabled. enable drums with !drum toggle")
    end
end

local function clearBarrel(ply)
    local barrelcount = 0
    for k, v in ipairs(ents.FindByClass("prop_physics")) do
        if v:GetModel() == "models/props_c17/oildrum001.mdl" or v:GetModel() == "models/props_c17/oildrum001_explosive.mdl" or v:GetModel() == "models/props_borealis/bluebarrel001.mdl" then
            ---@diagnostic disable-next-line: undefined-field
            if v.owner == ply:SteamID64() then
                v:Remove()
                barrelcount = barrelcount + 1
            end
        end
    end
    sendBarrelMessage(ply, "successfully cleared barrels: ", barrelcount)
end

local function wipeBarrel(ply)
    local barrelcount = 0
    if ply:IsAdmin() then
        for k, v in ipairs(ents.FindByClass("prop_physics")) do
            if v:GetModel() == "models/props_c17/oildrum001.mdl" or v:GetModel() == "models/props_c17/oildrum001_explosive.mdl" or v:GetModel() == "models/props_borealis/bluebarrel001.mdl" then
---@diagnostic disable-next-line: undefined-field
                if v.owner ~= nil then
                   v:Remove() 
                   barrelcount = barrelcount + 1
                end
            end
        end
        sendBarrelMessage(ply, "successfully wiped barrels: ", barrelcount)
    else
        sendBarrelMessage(ply, "sorry! to use this command, you must either be an admin or superadmin!")
    end
end


local function barrelHelp(ply)
    sendBarrelMessage(ply, "available commands:")
    sendBarrelMessage(ply, "!drum toggle - toggle drums on/off (admin only)")
    sendBarrelMessage(ply, "!drum spawn - spawn a drum")
    sendBarrelMessage(ply, "!drum clear - clear your spawned drums")
    sendBarrelMessage(ply, "!drum wipe - wipe all spawned drums (admin only)")
    sendBarrelMessage(ply, "!drum help - show this help message")
end

hook.Add("PlayerSay", "barrel", function(ply, text, teamChat)
    if string.lower(text) == "!drum toggle" then
        barrelSwitch(ply)
        return ""
    end
end)

hook.Add("PlayerSay", "barrelSpawn", function(ply, text, teamChat)
    if string.lower(text) == "!drum spawn" then
        spawnBarrel(ply)
        return ""
    end
end)

hook.Add("PlayerSay", "barrelClear", function(ply, text, teamChat)
    if string.lower(text) == "!drum clear" then
        clearBarrel(ply)
        print("clearing spawned barrels for " .. ply:Nick())
        return ""
    end
end)

hook.Add("PlayerSay", "barrelWipe", function(ply, text, teamChat)
    if string.lower(text) == "!drum wipe" then
        wipeBarrel(ply)
        print("wiping all spawned barrels from the server for " .. ply:Nick())
        return ""
    end
end)

hook.Add("PlayerSay", "barrelHelp", function(ply, text, teamChat)
    if string.lower(text) == "!drum help" then
        barrelHelp(ply)
        return ""
    end
end)

--[[
@xandlwithaz
https://github.com/xandlwithaz/drum-mod
https://steamcommunity.com/sharedfiles/filedetails/?id=3818711180
]]