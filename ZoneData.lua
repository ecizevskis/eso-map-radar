local ZT_ZONE = 1
local ZT_SUBZONE = 2
local ZT_DUNGEON = 3
local ZT_TRIAL = 4
local ZT_DELVE = 5

-- https://wiki.esoui.com/Zones

MapRadarZoneData = {
    -- Based on MapId

    -- ==============================================================================
    -- Glenumbra
    [1] = {
        type = ZT_ZONE,
        d1m = 0.0002610863,
        zoneIndex = 2
    },
    -- Crosswych
    [541] = {
        type = ZT_SUBZONE,
        d1m = 0.0015747160,
        zoneIndex = 2
    },
    -- Daggerfall
    [63] = {
        type = ZT_SUBZONE,
        d1m = 0.0012578294,
        zoneIndex = 2
    },
    -- Aldcroft
    [531] = {
        type = ZT_SUBZONE,
        d1m = 0.0019908294,
        zoneIndex = 2
    },
    -- Cryptwatch Fort
    [235] = {
        type = ZT_DELVE,
        d1m = 0.0028123719,
        zoneIndex = 127
    },
    -- Illesan Tower
    [237] = {
        type = ZT_DELVE,
        d1m = 0.0035836003,
        zoneIndex = 122
    },
    -- Mines of Khuras
    [228] = {
        type = ZT_DELVE,
        d1m = 0.0026436442,
        zoneIndex = 124
    },
    -- Enduum
    [203] = {
        type = ZT_DELVE,
        d1m = 0.0022164888,
        zoneIndex = 125
    },
    -- Ebon Crypt
    [215] = {
        type = ZT_DELVE,
        d1m = 0.0046966881,
        zoneIndex = 126
    },
    -- Silumm
    [111] = {
        type = ZT_DELVE,
        d1m = 0.0035572145,
        zoneIndex = 123
    },

    -- ==============================================================================
    -- Stormheaven
    [12] = {
        type = ZT_ZONE,
        d1m = 0.0002785960,
        zoneIndex = 4
    },

    -- Koeglin Village
    [532] = {
        type = ZT_SUBZONE,
        d1m = 0.0023558550,
        zoneIndex = 4
    },

    -- Portdun Watch
    [238] = {
        type = ZT_DELVE,
        d1m = 0.0051053457,
        zoneIndex = 128
    },

    -- Koeglin Mine
    [202] = {
        type = ZT_DELVE,
        d1m = 0.0033984871,
        zoneIndex = 129
    },

    -- Farangel's Delve
    [249] = {
        type = ZT_DELVE,
        d1m = 0.0054729967,
        zoneIndex = 131
    },

    -- Bonesnap Ruins
    [189] = {
        type = ZT_DUNGEON,
        d1m = 0.0022009789,
        zoneIndex = 27
    },

    -- ==============================================================================
    -- Stros M'Kai
    [201] = {
        type = ZT_ZONE,
        d1m = 0.0006635036,
        zoneIndex = 305
    },
    -- Port Hunding
    [530] = {
        type = ZT_SUBZONE,
        d1m = 0.0015520529,
        zoneIndex = 305
    },

    -- ==============================================================================
    -- Betnikh
    [227] = {
        type = ZT_ZONE,
        d1m = 0.0005905960,
        zoneIndex = 306
    },
    -- Stonetooth Fortress
    [649] = {
        type = ZT_SUBZONE,
        d1m = 0.0017452239,
        zoneIndex = 306
    },

    -- ==============================================================================
    -- Shadowfen
    [26] = {
        type = ZT_ZONE,
        d1m = 0.0003289615,
        zoneIndex = 19
    },

    -- Stormhold
    [217] = {
        type = ZT_SUBZONE,
        d1m = 0.0020928362,
        zoneIndex = 19
    },

    -- Alik'r Desert
    [30] = {
        type = ZT_ZONE,
        d1m = 0.0002559392,
        zoneIndex = 17
    },

    -- Reaper's March
    [256] = {
        type = ZT_ZONE,
        d1m = 0.0003053667,
        zoneIndex = 180
    },

    -- The Rift
    [125] = {
        type = ZT_ZONE,
        d1m = 0.0002638825,
        zoneIndex = 16
    },

    -- ==============================================================================
    -- Northern Elsweyr
    [1555] = {
        type = ZT_ZONE,
        d1m = 0.0002062994,
        zoneIndex = 682
    },
    -- Rimmen
    [1576] = {
        type = ZT_SUBZONE,
        d1m = 0.0015244612,
        zoneIndex = 682
    },

    -- ==============================================================================
    -- xxxxxxx
    [0] = {
        type = ZT_ZONE,
        d1m = 11111111,
        zoneIndex = 0
    }
}
