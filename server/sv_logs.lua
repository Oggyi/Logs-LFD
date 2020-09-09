util.AddNetworkString("frame")
util.AddNetworkString("SendeSpielerNamen")
util.AddNetworkString("SendeVictimNamen")
util.AddNetworkString("SendeAttackerNamen")


    hook.Add("PlayerInitialSpawn", "Connects", function(ply)
        net.Start("SendeSpielerNamen")
        net.WriteString(ply:Name())
        net.Broadcast()
    end)


hook.Add("PlayerDisconnected", "Disconnects", function(ply)
    net.Start("SendeSpielerNamen")
        net.WriteString(ply:Name())
        net.Broadcast()
end)


hook.Add("PlayerDeath", "Dead", function(victim, inflictor, attacker)
    net.Start("SendeVictimNamen")
    net.WriteString(victim:Name())
    net.WriteString(attacker:Name())
            net.Broadcast()

end)

--[[
    hook.Add("PlayerSay", "logs", function ( ply, text )
if string.lower(text) == "!logs" then
    net.Start("frame")
    net.Send(ply)
    return  ""
    end
end)
--]]