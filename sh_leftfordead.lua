--[[

    - Ein Spieler gibt einen Command ein um das Spiel zu starten
    - In dem Zug teleportieren sich die anderen Spieler um
      den Ausgangsspieler herum
    - Als nächstes spawnt die erste Welle in einem Kreis um diese
      Spieler herum


LeftForDead: {
    Spieler: {
        ["7615416541561654"]: {
            nick = "Oggyi",
            welleueberlebt = 1
        },

    }
    Welle = 6
    Positionen: {
        [1] = Vector(),
        [2] = Vector()
    }
}

Table ausprinten lassen Ingame:
    sv_cheats 1
    lua_run PrintTable(LeftForDead)
    lua_run print(Entity(1):ABFRAGE())

Erklärung:
    - Links neben einem Doppelpunkt -> Tabellenname
    - Links von einem Gleichzeichen -> Key
    - Rechts von eine Gleichzeichen -> Value

]]

LeftForDead = LeftForDead or {}
LeftForDead.Spieler = LeftForDead.Spieler or {}

LeftForDead.Welle = 1
LeftForDead.NPC = 0

TEAM_KAEMPFER = 1
TEAM_SPRENG = 2
TEAM_SCHROTZ = 3
TEAM_SCHARF = 4

team.SetUp( TEAM_KAEMPFER, "Kaempfer", Color(255,255,255) )
team.SetUp( TEAM_SPRENG, "Sprengstoff", Color(255,255,255) )
team.SetUp( TEAM_SCHROTZ, "Schrotzenmann", Color(255,255,255) )
team.SetUp( TEAM_SCHARF, "Scharfschütze", Color(255,255,255) )

LeftForDead.Teams = {
    [TEAM_KAEMPFER] = {
        waffen = {"m9k_hk45", "m9k_vector", "m9k_machete"},
        model = "models/player/arctic.mdl",
        ammo = {"m9k_ammo_pistol", "m9k_ammo_smg"},
    },
    [TEAM_SPRENG] = {
        waffen = {"m9k_glock", "m9k_m79gl", "m9k_rpg7"},
        model = "models/player/arctic.mdl",
        ammo = {"m9k_ammo_pistol", "m9k_ammo_rockets", "m9k_ammo_rockets" },
    },
    [TEAM_SCHROTZ] = {
        waffen = {"m9k_1897winchester", "m9k_hk45", "m9k_machete"},
        model = "models/player/arctic.mdl",
        ammo = {"m9k_ammo_pistol", "m9k_ammo_buckshot"},
    },
    [TEAM_SCHARF] = {
        waffen = {"m9k_intervention", "m9k_glock", "m9k_machete"},
        model = "models/player/arctic.mdl",
        ammo = {"m9k_ammo_pistol", "m9k_ammo_sniper_rounds"},
    },
}





LeftForDead.Monster = {
    [1] = {
        hp = 100,
        anzahl = 35,
        npcart = {"npc_fastzombie_torso", "npc_zombie", "npc_headcrab", "npc_fastzombie"},
    },
    [2] = {
        hp = 150,
        anzahl = 50,
        npcart = {"npc_fastzombie", "npc_headcrab", "npc_zombie"},
    },
    [3] = {
        hp = 200,
        anzahl = 65,
        npcart = {"npc_fastzombie", "npc_poisonzombie", "npc_headcrab_fast"},
    },
    ["Spawn"] = {}
}














