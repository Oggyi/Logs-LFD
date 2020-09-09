

net.Receive("SpielerChangeTeam", function()
    local spielerteam = net.ReadInt(8)
    local teamname = team.GetName(spielerteam)
    chat.AddText("Du bist nun im Team " .. teamname)
end)

--[[hook.Add("SpawnMenuOpen", "qmenu", function()
    if IsSuperAdmin() then
        return true 
    end
end)


hook.Add("SpawnMenuOpen", "qmenu", function()
    if not LeftForDead.Spieler [LocalPlayer():IsSuperAdmin()] then 
     return false
 else
        return true
    end
end)

--]]
