
resource.AddWorkshop("144982052")
resource.AddWorkshop("128093075")
resource.AddWorkshop("834520203")
resource.AddWorkshop("128089118")
resource.AddWorkshop("749554285")
resource.AddWorkshop("639539553")
util.AddNetworkString("SpielerChangeTeam")

function PointOnCircle(ang, radius, offX, offY)
    ang = math.rad(ang)
    local x = math.cos(ang) * radius + offX
    local y = math.sin(ang) * radius + offY

    return x, y
end

function StarteSpiel(ply, text)
    if string.lower(text) == "!start" then
        --if not ply:IsSuperAdmin() then PrintMessage(HUD_PRINTTALK,"Du bist kein Superadmin") return "" end
        local allespieler = player.GetAll()
        local anzahlspieler = #allespieler --How many squares do we want to draw?
        local interval = (360 / anzahlspieler)
        local radius = 360
        LeftForDead.Monster["Spawn"].x = ply:GetPos().x
        LeftForDead.Monster["Spawn"].y = ply:GetPos().y
        LeftForDead.Monster["Spawn"].z = ply:GetPos().z + 2

        if anzahlspieler >= 4 then
            for degrees = 1, 360, interval do
                local x, y = PointOnCircle(degrees, radius, LeftForDead.Monster["Spawn"].x, LeftForDead.Monster["Spawn"].y)
                local zahl

                for k, v in pairs(allespieler) do
                    if zahl ~= degrees and not v.teleportiert then
                        v.teleportiert = true
                        zahl = degrees
                        v:SetTeam(math.random(TEAM_KAEMPFER, TEAM_SCHARF))
                        v:SetPos(Vector(x, y, LeftForDead.Monster["Spawn"].z))
                        Teamgeschichte(v)
                        net.Start("SpielerChangeTeam")
                        net.WriteInt(v:Team(), 8)
                        net.Send(v)
                    end
                end
            end

            Wellensystem()
        else
            PrintMessage(HUD_PRINTTALK, "Ihr braucht noch " .. 4 - #allespieler .. " weitere Spieler, um das Spiel zu beginnen.")

            return ""
        end
    end
end

local anzahlnpc = 0
local hp = 0

function Wellensystem()
    anzahlnpc = LeftForDead.Monster[LeftForDead.Welle].anzahl
    hp = LeftForDead.Monster[LeftForDead.Welle].hp
    local neuerintervall = (360 / anzahlnpc)
    local coolererradius = 1080

    for degrees = 1, 360, neuerintervall do
        local x, y = PointOnCircle(degrees, coolererradius, LeftForDead.Monster["Spawn"].x, LeftForDead.Monster["Spawn"].y)

        --for i = 1, 5 do
        timer.Simple(2, function()
            local npc = ents.Create(table.Random(LeftForDead.Monster[LeftForDead.Welle].npcart))
            npc:SetPos(Vector(x, y, LeftForDead.Monster["Spawn"].z))
            npc:SetHealth(LeftForDead.Monster[LeftForDead.Welle].hp)
            npc:Spawn()
            LeftForDead.NPC = LeftForDead.NPC + 1
        end)
        --end
    end

    for k, v in pairs(player.GetAll()) do
        v:SetHealth(100)
    end
end

hook.Add("OnNPCKilled", "NPCKILLCOUNTER", function(npc, attacker, tatwaffe)
    LeftForDead.NPC = LeftForDead.NPC - 1
    PrintMessage(HUD_PRINTTALK, "Ihr müsst noch " .. LeftForDead.NPC .. " weitere Monster töten.")

    if LeftForDead.NPC == 0 and LeftForDead.Welle ~= 3 then
        LeftForDead.Welle = LeftForDead.Welle + 1
        Wellensystem()
    elseif LeftForDead.NPC == 0 and LeftForDead.Welle == 3 then
        PrintMessage(HUD_PRINTTALK, "Spiel vorbei, gz.")
    end
end)

hook.Add("PlayerSay", "StarteSpielModus", StarteSpiel)

hook.Add("PlayerSay", "StopSpielModus", StopSpiel)


hook.Add("PlayerInitialSpawn", "InitialisiereSpieler", function(ply)
    print("Trage die Daten der Spieler ein...")
    LeftForDead.Spieler[ply:SteamID64()] = LeftForDead.Spieler[ply:SteamID64()] or {}
    LeftForDead.Spieler[ply:SteamID64()].nick = ply:Nick()
    LeftForDead.Spieler[ply:SteamID64()].welleueberlebt = 0

    if not ply:IsSuperAdmin() then
        ply:SetTeam(TEAM_SPECTATOR)
        ply:SetMoveType(MOVETYPE_NOCLIP)
            ply:SetNoDraw(true)
            ply:GodEnable()
            ply:StripWeapons()
    end
end)

--hook.Add("PlayerChangedTeam", "Teamwechsel", Teamwechsel)
function Teamgeschichte(ply)
    local newTeam = ply:Team()

    if newTeam == TEAM_SPECTATOR then
        timer.Simple(0.2, function()
            ply:SetMoveType(MOVETYPE_NOCLIP)
            ply:SetNoDraw(true)
            ply:GodEnable()
            ply:StripWeapons()
        end)
    elseif newTeam == TEAM_KAEMPFER or newTeam == TEAM_SPRENG or newTeam == TEAM_SCHROTZ or newTeam == TEAM_SCHARF then
        timer.Simple(0.2, function()
            ply:SetMoveType(MOVETYPE_NONE)
            ply:SetNoDraw(false)
            ply:GodDisable()
            ply:StripWeapons()

            for i = 1, #LeftForDead.Teams[newTeam].waffen do
                ply:Give(LeftForDead.Teams[newTeam].waffen[i])
            end

            ply:SetModel(LeftForDead.Teams[newTeam].model)

            for i = 1, #LeftForDead.Teams[newTeam].ammo do
                ply:GiveAmmo(300, LeftForDead.Teams[newTeam].ammo[i], true)
            end
        end)
    end
end

hook.Add("Think", "NPCAutoSeekPlayer", function()
    local npcs = ents.GetAll()
    local plys = player.GetAll()
    local plyCount = #plys
    -- No point trying to give NPCs a player when there are none
    if (plyCount == 0) then return end

    -- Loop over all entities and check for NPCs
    for i = 1, #npcs do
        local npc = npcs[i]

        -- If this entity is an NPC without an enemy, give them one
        if (npc:IsNPC() and not IsValid(npc:GetEnemy())) then
            local curPly = nil -- Closest player
            local curPlyPos = nil -- Position of closest player
            local curDist = math.huge -- Lowest distance between npc and player
            local npcPos = npc:GetPos() -- Position of the NPC

            -- Loop over all players to check their distance from the NPC
            for i = 1, plyCount do
                local ply = plys[i]

                -- Only consider players that this NPC hates
                if (npc:Disposition(ply) == D_HT) then
                    -- TODO: You can optimise looking up each player's position (constant)
                    -- for every NPC by generating a table of:
                    --- key = player identifier (entity object, UserID, EntIndex, etc.)
                    --- value = player's position vector
                    -- for the first NPC that passes to this part of the code,
                    -- then reuse it for other NPCs
                    local plyPos = ply:GetPos()
                    -- Use DistToSqr for distance comparisons since
                    -- it's more efficient than Distance, and the
                    -- non-squared distance isn't needed for anything
                    local dist = npcPos:DistToSqr(plyPos)

                    -- If the new distance is lower, update the player information
                    if (dist < curDist) then
                        curPly = ply
                        curPlyPos = plyPos
                        curDist = dist
                    end
                end
            end

            -- curPly is guarenteed to be valid since this code
            -- will only run if there is at least one player
            npc:SetEnemy(curPly)
            npc:UpdateEnemyMemory(curPly, curPlyPos)
        end
    end
end)


--[[hook.Add( "PlayerShouldTakeDamage", "AntiTeamkill", function( ply, attacker )

    if ( attacker:IsPlayer() ) then
        return false

    elseif ( attacker:IsNPC() ) then
        return true
    else
        attacker:GetOwner()
        end

        if (ply:Team() == attacker:Team() ) then
        return false

end
end)
--]]
         function StopSpiel(ply, text)
    if string.lower(text) == "!stop" then
    game.CleanUpMap()

for k,v in pairs (player.GetAll())
    do v:Kill()
    v:SetTeam(TEAM_SPECTATOR)
    print( team.GetName( Entity( 1 ):Team(TEAM_SPECTATOR) ) )
      end
    end
end

