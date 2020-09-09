
      function WirArbeitenMitDateien()
            file.CreateDir("logs")
            file.Write("logs/Connects.txt")
            file.Write("logs/Disconnects.txt")
            file.Write("logs/Tode.txt")
            file.Write("logs/Spielerschaden.txt")
            file.Write("logs/Chat.txt")
        end

    hook.Add("Initialize", "WerConnectetis", WirArbeitenMitDateien)

    net.Receive("SendeSpielerNamen", function()
        local Timestamp = os.time()
        local TimeString = os.date("%d.%m.%Y - %H:%M:%S", Timestamp)
        local spieler = net.ReadString()
        
        file.Append("logs/connects.txt", "\n[" .. TimeString .. "] " .. spieler .. " hat sich auf den Server verbunden.")
    end)
    net.Receive("LogsOffen", function()
        chat.AddText(file.Read( "logs/Connects.txt", "DATA" ))
    end)



    hook.Add("Initialize", "WerDisconnectedis", WirArbeitenMitDateien)

        net.Receive("SendeSpielerNamen", function()
        local Timestamp = os.time()
        local TimeString = os.date("%d.%m.%Y - %H:%M:%S", Timestamp)
        local spieler = net.ReadString()

        file.Append("logs/Disconnects.txt", "\n[" .. TimeString .. "] " .. spieler .. " Ist vom Server gegangen.")
    end)
    net.Receive("LogsOffen", function()
        chat.AddText(file.Read( "logs/Disconnects.txt", "DATA" ))
    end)



--[[hook.Add("Initialize", "WerTotis",  WirArbeitenMitDateien)
net.Receive("SendeVictimNamen", function()
net.Receive("SendeAttackerNamen", function()

        local Timestamp = os.time()
        local TimeString = os.date("%d.%m.%Y - %H:%M:%S", Timestamp)
        local victim = net.ReadString("SendeVictimNamen")
        local attacker = net.ReadString("SendeAttackerNamen")

        file.Append("logs/tode.txt", "\n[" .. TimeString .. "] " .. victim .. " wurde von " .. attacker .. " getötet.")
    end)
    net.Receive("LogsOffen", function()
        chat.AddText(file.Read( "logs/tode.txt", "DATA" ))
        end)
    end)
]]--


net.Receive("frame", function()

        local frame = vgui.Create("DFrame")
        frame:SetSize( 1000, 720)
        frame:Center()
        frame:SetVisible(true)
        frame:MakePopup()
        frame:SetDraggable(false)
        frame:SetTitle("Logs")

        frame.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color( 136, 136, 136))


            local CatList = vgui.Create( "DCategoryList", frame )
CatList:Dock( FILL )

local Cat = CatList:Add( "" )
local button = Cat:Add( "Connects" )
local button = Cat:Add( "Disconnect" )
local button = Cat:Add( "Tode" )
local button = Cat:Add( "Spielerschaden" )
local button = Cat:Add( "Chat" )

button.DoClick = function()

vgui.Create( "DFrame" )
frame:SetSize( 400, 200 )
frame:Center()
frame:MakePopup()

local TextEntry = vgui.Create( "DTextEntry", frame ) -- create the form as a child of frame
TextEntry:SetPos( 25, 50 )
TextEntry:SetSize( 75, 85 )
TextEntry:SetValue( "Placeholder Text" )
TextEntry.OnEnter = function( self )
chat.AddText( self:GetValue() )	-- print the form's text as server text
end

end

end
        frame:SetDeleteOnClose(true)

        local x,y = frame:GetSize()

        local button = vgui.Create("DButton", frame)
        button:SetText("Schließen")
        button:SetPos(x-100,4)
        button:SetSize(100, 22)
        button.DoClick = function()
        frame:Close()
        end
end)



