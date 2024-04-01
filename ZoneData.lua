local ZT_NONE = 0
local ZT_ZONE = 1
local ZT_SUBZONE = 2
local ZT_DUNGEON = 3
local ZT_TRIAL = 4
local ZT_DELVE = 5
local ZT_CAVE = 6
local ZT_INDOOR = 7
local ZT_MINE = 8
local ZT_CRYPT = 9
local ZT_RUIN = 10
-- quest isolated areas? instances?
-- ZT_SOLOINSTANCE ????

-- https://wiki.esoui.com/Zones

-- LuaFormatter off

MapRadarZoneData = {  -- Based on MapId
--  ==============================================================================
[1] = { type = ZT_ZONE, d1m = 0.0002610863, zoneIndex = 2 }, -- Glenumbra
[541] = { type = ZT_SUBZONE, d1m = 0.0015747160, zoneIndex = 2 }, -- Crosswych
[63] = { type = ZT_SUBZONE, d1m = 0.0012578294, zoneIndex = 2 }, -- Daggerfall
[531] = { type = ZT_SUBZONE, d1m = 0.0019908294, zoneIndex = 2 }, -- Aldcroft
[235] = { type = ZT_DELVE, d1m = 0.0028123719, zoneIndex = 127 }, -- Cryptwatch Fort
[237] = { type = ZT_DELVE, d1m = 0.0035836003, zoneIndex = 122 }, -- Illesan Tower
[228] = { type = ZT_DELVE, d1m = 0.0026436442, zoneIndex = 124 }, -- Mines of Khuras
[203] = { type = ZT_DELVE, d1m = 0.0022164888, zoneIndex = 125 }, -- Enduum
[215] = { type = ZT_DELVE, d1m = 0.0046966881, zoneIndex = 126 }, -- Ebon Crypt
[111] = { type = ZT_DELVE, d1m = 0.0035572145, zoneIndex = 123 }, -- Silumm
-- ============================================================================== 
[12] = { type = ZT_ZONE, d1m = 0.0002785960, zoneIndex = 4 }, -- Stormheaven
[532] = { type = ZT_SUBZONE, d1m = 0.0023558550, zoneIndex = 4 }, -- Koeglin Village
[238] = { type = ZT_DELVE, d1m = 0.0051053457, zoneIndex = 128 }, -- Portdun Watch
[202] = { type = ZT_DELVE, d1m = 0.0033984871, zoneIndex = 129 }, -- Koeglin Mine
[249] = { type = ZT_DELVE, d1m = 0.0054729967, zoneIndex = 131 }, -- Farangel's Delve
[189] = { type = ZT_DUNGEON, d1m = 0.0022009789, zoneIndex = 27 }, -- Bonesnap Ruins
--  ============================================================================== 
[201] = { type = ZT_ZONE, d1m = 0.0006635036, zoneIndex = 305 }, -- Stros M'Kai
[530] = { type = ZT_SUBZONE, d1m = 0.0015520529, zoneIndex = 305 }, -- Port Hunding
--  ============================================================================== 
[227] = { type = ZT_ZONE, d1m = 0.0005905960, zoneIndex = 306 }, -- Betnikh
[649] = { type = ZT_SUBZONE, d1m = 0.0017452239, zoneIndex = 306 }, -- Stonetooth Fortress
-- ============================================================================== 
[26] = { type = ZT_ZONE, d1m = 0.0003289615, zoneIndex = 19 }, -- Shadowfen
[217] = { type = ZT_SUBZONE, d1m = 0.0020928362, zoneIndex = 19 }, -- Stormhold
[544] = { type = ZT_SUBZONE, d1m = 0.0016061114, zoneIndex = 19 }, -- Alten Corimont
-- ============================================================================== 
[30] = { type = ZT_ZONE, d1m = 0.0002428292, zoneIndex = 17 }, -- Alik'r Desert
[83] = { type = ZT_SUBZONE, d1m = 0.0011790012, zoneIndex = 17 }, -- Sentinel
[538] = { type = ZT_SUBZONE, d1m = 0.0019356809, zoneIndex = 17 }, -- Kozanset
[539] = { type = ZT_SUBZONE, d1m = 0.0018257869, zoneIndex = 17 }, -- Bergama
[246] = { type = ZT_DELVE, d1m = 0.0029204309, zoneIndex = 140 }, -- Santaki
-- ============================================================================== 
[256] = { type = ZT_ZONE, d1m = 0.0003053667, zoneIndex = 180 }, -- Reaper's March
-- ============================================================================== 
[125] = { type = ZT_ZONE, d1m = 0.0002482005, zoneIndex = 16 }, -- The Rift
[542] = { type = ZT_SUBZONE, d1m = 0.0017322909, zoneIndex = 16 }, -- Shor's Stone
[543] = { type = ZT_SUBZONE, d1m = 0.0013857898, zoneIndex = 16 }, -- Nimalten
[198] = { type = ZT_SUBZONE, d1m = 0.0017220367, zoneIndex = 16 }, -- Riften
--  ============================================================================== 
[1555] = { type = ZT_ZONE, d1m = 0.0002062994, zoneIndex = 682 }, -- Northern Elsweyr
[1576] = { type = ZT_SUBZONE, d1m = 0.0015244612, zoneIndex = 682 }, -- Rimmen
[1591] = { type = ZT_SUBZONE, d1m = 0.0023562885, zoneIndex = 682 }, -- Riverhold
[1663] = { type = ZT_SUBZONE, d1m = 0.0022089556, zoneIndex = 682 }, -- The Stitches
[1660] = { type = ZT_CAVE, d1m = 0.0033314688, zoneIndex = 4294967296 }, -- Smuggler's Hideout
[1673] = { type = ZT_DELVE, d1m = 0.0015927010, zoneIndex = 711 }, -- Desert Wind Caverns
[1595] = { type = ZT_DELVE, d1m = 0.0018650693, zoneIndex = 686 }, -- Abode of Ignominy
[1616] = { type = ZT_DELVE, d1m = 0.0022569323, zoneIndex = 687 }, -- Predator Mesa
[1590] = { type = ZT_DELVE, d1m = 0.0022419495, zoneIndex = 688 }, -- Tomb of the Serpents
[1626] = { type = ZT_DELVE, d1m = 0.0019957223, zoneIndex = 690 }, -- The Tangle
[1608] = { type = ZT_DELVE, d1m = 0.0019909050, zoneIndex = 689 }, -- Darkpool Mine
[1628] = { type = ZT_CAVE, d1m = 0.0044595195, zoneIndex = 682 }, -- Merryvale Sugar Farm Caves
--  ============================================================================== 
[9] = { type = ZT_ZONE, d1m = 0.0002828988, zoneIndex = 181 }, -- Grahtwood
[445] = { type = ZT_SUBZONE, d1m = 0.0012880952, zoneIndex = 181 }, -- Elden Root
[450] = { type = ZT_INDOOR, d1m = 0.0044588132, zoneIndex = 181 }, -- Elden Root Ground Level
[446] = { type = ZT_INDOOR, d1m = 0.0053404265, zoneIndex = 181 }, -- Elden Root Upper Floor
[571] = { type = ZT_INDOOR, d1m = 0.0053849253, zoneIndex = 181 }, -- Elden Root Fighters Guild
[449] = { type = ZT_INDOOR, d1m = 0.0053373751, zoneIndex = 181 }, -- Elden Root Mage Guild
[451] = { type = ZT_INDOOR, d1m = 0.0053414254, zoneIndex = 181 }, -- Elden Root Throne Room
[536] = { type = ZT_SUBZONE, d1m = 0.0027440101, zoneIndex = 181 }, -- Redfur Trading Post
[512] = { type = ZT_SUBZONE, d1m = 0.0013775114, zoneIndex = 181 }, -- Haven
[414] = { type = ZT_DELVE, d1m = 0.0041934484, zoneIndex = 262 }, -- Wormroot Depths
[393] = { type = ZT_DELVE, d1m = 0.0039592054, zoneIndex = 261 }, -- Vinedeath Cave
[396] = { type = ZT_DELVE, d1m = 0.0034181370, zoneIndex = 234 }, -- Burroot Kwama Mine
[395] = { type = ZT_DELVE, d1m = 0.0033485392, zoneIndex = 235 }, -- Mobar Mine
[394] = { type = ZT_DELVE, d1m = 0.0033866176, zoneIndex = 260 }, -- The Scuttle Pit
[404] = { type = ZT_DELVE, d1m = 0.0042121438, zoneIndex = 233 }, -- Ne Salas
[283] = { type = ZT_DUNGEON, d1m = 0.0027290363, zoneIndex = 20 }, -- Root Sunder Ruins
--  ============================================================================== 
[108] = { type = ZT_ZONE, d1m = 0.0016754935, zoneIndex = 100 }, -- Eyevea
--  ============================================================================== 
[7] = { type = ZT_ZONE, d1m = 0.0002737997, zoneIndex = 9 }, -- Stonefalls
[24] = { type = ZT_SUBZONE, d1m = 0.0013623396, zoneIndex = 9 }, -- Davon's Watch
[510] = { type = ZT_SUBZONE, d1m = 0.0016319819, zoneIndex = 9 }, -- Kragenmoor
[511] = { type = ZT_SUBZONE, d1m = 0.0012971857, zoneIndex = 9 }, -- Ebonheart
--  ============================================================================== 
[143] = { type = ZT_ZONE, d1m = 0.0002456598, zoneIndex = 179 }, -- Auridon
[243] = { type = ZT_SUBZONE, d1m = 0.0012199237, zoneIndex = 179 }, -- Vulkhel Guard
[545] = { type = ZT_SUBZONE, d1m = 0.0014369003, zoneIndex = 179 }, -- Skywatch
[540] = { type = ZT_SUBZONE, d1m = 0.0014832046, zoneIndex = 179 }, -- Firsthold
[181] = { type = ZT_DELVE, d1m = 0.0029342177, zoneIndex = 195 }, -- Wansalen
[179] = { type = ZT_DELVE, d1m = 0.0037825837, zoneIndex = 192 }, -- Ondil
[182] = { type = ZT_DELVE, d1m = 0.0038365942, zoneIndex = 196 }, -- Mehrunes' Spite
[186] = { type = ZT_DELVE, d1m = 0.0025004844, zoneIndex = 194 }, -- Entila's Folly
[178] = { type = ZT_DELVE, d1m = 0.0029775446, zoneIndex = 193 }, -- Del's Claim
[180] = { type = ZT_DELVE, d1m = 0.0031039448, zoneIndex = 197 }, -- Bewan
[268] = { type = ZT_DUNGEON, d1m = 0.0018180335, zoneIndex = 268 }, -- Toothmaul Gully
--  ============================================================================== 
[13] = { type = ZT_ZONE, d1m = 0.0002437870, zoneIndex = 10 }, -- Deshaan
[205] = { type = ZT_SUBZONE, d1m = 0.0011725358, zoneIndex = 10 }, -- Mournhold
[537] = { type = ZT_SUBZONE, d1m = 0.0020445189, zoneIndex = 10 }, -- Narsis
[126] = { type = ZT_CAVE, d1m = 0.0029097984, zoneIndex = 87 }, -- Deepcrag Den
--  ============================================================================== 
[61] = { type = ZT_ZONE, d1m = 0.0002429406, zoneIndex = 15 }, -- Eastmarch
[160] = { type = ZT_SUBZONE, d1m = 0.001828079, zoneIndex = 15 }, -- Windhelm
[578] = { type = ZT_SUBZONE, d1m = 0.0019801475, zoneIndex = 15 }, -- Fort Amol
[163] = { type = ZT_DELVE, d1m = 0.0037132925, zoneIndex = 158 }, -- The Chill Hollow
[166] = { type = ZT_DELVE, d1m = 0.004134479, zoneIndex = 161 }, -- The Frigid Grotto
--  ============================================================================== 
[1887] = { type = ZT_ZONE, d1m = 0.0001989522, zoneIndex = 835 }, -- Blackwood
[2018] = { type = ZT_SUBZONE, d1m = 0.0024283691, zoneIndex = 835 }, -- Gideon
[1940] = { type = ZT_SUBZONE, d1m = 0.0020021955, zoneIndex = 835 }, -- Leyawiin
[2000] = { type = ZT_DUNGEON, d1m = 0.000729305, zoneIndex = 835 }, -- Atoll of Immolation
--  ============================================================================== 
[0] = { type = ZT_ZONE, d1m = 11111111, zoneIndex = 0 }  -- xxxxxxx
}

-- LuaFormatter on
