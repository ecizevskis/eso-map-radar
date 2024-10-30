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
local ZT_SEWERS = 11
local ZT_COSMIC = 12
local ZT_TEMPLE = 13
local ZT_CASTLE = 14
local ZT_UNDERWORLD = 15
local ZT_POCKET = 16
local ZT_CELLAR = 17
local ZT_MINIZONE = 18
-- quest isolated areas? instances?
-- ZT_SOLOINSTANCE ????

-- https://wiki.esoui.com/Zones

-- LuaFormatter off

MapRadarZoneData = {  -- Based on MapId
--  ==============================================================================
[1] = { type = ZT_ZONE, d1m = 0.0002610863 }, -- Glenumbra
[541] = { type = ZT_SUBZONE, d1m = 0.0015747160 }, -- Crosswych
[63] = { type = ZT_SUBZONE, d1m = 0.0012578294 }, -- Daggerfall
[531] = { type = ZT_SUBZONE, d1m = 0.0019908294 }, -- Aldcroft
[235] = { type = ZT_DELVE, d1m = 0.0028123719 }, -- Cryptwatch Fort
[237] = { type = ZT_DELVE, d1m = 0.0035836003 }, -- Illesan Tower
[228] = { type = ZT_DELVE, d1m = 0.0026436442 }, -- Mines of Khuras
[203] = { type = ZT_DELVE, d1m = 0.0022164888 }, -- Enduum
[215] = { type = ZT_DELVE, d1m = 0.0046966881 }, -- Ebon Crypt
[111] = { type = ZT_DELVE, d1m = 0.0035572145 }, -- Silumm
[99] = { type = ZT_NONE, d1m = 0.0044524865 }, -- Bad Man's Hallows - Entrance
[65] = { type = ZT_NONE, d1m = 0.0023318648 }, -- Bad Man's Hallows
[64] = { type = ZT_NONE, d1m = 0.0029251075 }, -- Cath Bedraud
[253] = { type = ZT_NONE, d1m = 0.0034552444 }, -- Tomb of Lost Kings
[801] = { type = ZT_NONE, d1m = 0.0077288139 }, -- East Hut Portal Cave
[799] = { type = ZT_NONE, d1m = 0.0078599712 }, -- South Hut Portal Cave
[802] = { type = ZT_NONE, d1m = 0.0064668647 }, -- West Hut Portal Cave
[803] = { type = ZT_NONE, d1m = 0.0087072519 }, -- North Hut Portal Cave
[556] = { type = ZT_NONE, d1m = 0.0046547702 }, -- Themond Mine
[174] = { type = ZT_NONE, d1m = 0.0025699957 }, -- Spindleclutch I
[1156] = { type = ZT_NONE, d1m = 0.0024960189 }, -- Spindleclutch II
[2044] = { type = ZT_NONE, d1m = 0.0024485171 }, -- Red Petal Bastion Exterior

-- ============================================================================== 
[12] = { type = ZT_ZONE, d1m = 0.0002785960 }, -- Stormheaven
[34] = { type = ZT_SUBZONE, d1m = 0.0022362059 }, -- Alcaire Castle
[33] = { type = ZT_SUBZONE, d1m = 0.0014053201 }, -- Wayrest
[532] = { type = ZT_SUBZONE, d1m = 0.0023558550 }, -- Koeglin Village
[238] = { type = ZT_DELVE, d1m = 0.0051053457 }, -- Portdun Watch
[202] = { type = ZT_DELVE, d1m = 0.0033984871 }, -- Koeglin Mine
[249] = { type = ZT_DELVE, d1m = 0.0054729967 }, -- Farangel's Delve
[189] = { type = ZT_DUNGEON, d1m = 0.0022009789 }, -- Bonesnap Ruins

--  ============================================================================== 
[201] = { type = ZT_ZONE, d1m = 0.0006635036 }, -- Stros M'Kai
[530] = { type = ZT_SUBZONE, d1m = 0.0015520529 }, -- Port Hunding

--  ============================================================================== 
[227] = { type = ZT_ZONE, d1m = 0.0005905960 }, -- Betnikh
[649] = { type = ZT_SUBZONE, d1m = 0.0017452239 }, -- Stonetooth Fortress

-- ============================================================================== 
[26] = { type = ZT_ZONE, d1m = 0.0003289615 }, -- Shadowfen
[217] = { type = ZT_SUBZONE, d1m = 0.0020928362 }, -- Stormhold
[544] = { type = ZT_SUBZONE, d1m = 0.0016061114 }, -- Alten Corimont
[836] = { type = ZT_RUIN, d1m = 0.00269393 }, -- Cold-Blood Cavern
[875] = { type = ZT_COSMIC, d1m = 0.0037631993 }, -- Dyzera's Realm
[132] = { d1m = 0.0029541605 }, -- Silyanorn Ruins
[133] = { d1m = 0.0049308737 }, -- Odious Chapel
[135] = { d1m = 0.0055138706 }, -- Ruins of Ten-Maur-Wolk
[136] = { d1m = 0.004416924 }, -- Sunscale Ruins
[137] = { d1m = 0.0046688916 }, -- Temple of Sul
[138] = { d1m = 0.0036698688 }, -- White Rose Prison Dungeon
[139] = { d1m = 0.0019522124 }, -- Loriasel
[144] = { d1m = 0.0022893343 }, -- Sanguine's Demesne
[146] = { d1m = 0.0035593808 }, -- Atanaz Ruins
[147] = { d1m = 0.0032509694 }, -- Onkobra Kwama Mine
[148] = { d1m = 0.0033360541 }, -- Chid-Moska Ruins
[149] = { d1m = 0.0043885207 }, -- Shrine of the Black Maw
[150] = { d1m = 0.0033062593 }, -- Gandranen Ruins
[155] = { d1m = 0.0044852835 }, -- Broken Tusk
[274] = { d1m = 0.0051390809 }, -- Lair of the Skin Stealer
[561] = { d1m = 0.0045697183 }, -- Mud Tree Mine
[562] = { d1m = 0.0040452751 }, -- Vision of the Hist
[563] = { d1m = 0.0028651244 }, -- Abagarlas
[650] = { d1m = 0.0082642865 }, -- Mudshallow Cave
[716] = { d1m = 0.006844773 }, -- Stormhold Guild Hall
[720] = { d1m = 0.0102140763 }, -- Stormhold Mortuary
[722] = { d1m = 0.0067543096 }, -- Percolating Mire
[723] = { d1m = 0.0074934593 }, -- Hissmir Ruins



-- ============================================================================== 
[30] = { type = ZT_ZONE, d1m = 0.0002428292 }, -- Alik'r Desert
[83] = { type = ZT_SUBZONE, d1m = 0.0011790012 }, -- Sentinel
[538] = { type = ZT_SUBZONE, d1m = 0.0019356809 }, -- Kozanset
[539] = { type = ZT_SUBZONE, d1m = 0.0018257869 }, -- Bergama
[246] = { type = ZT_DELVE, d1m = 0.0029204309 }, -- Santaki
[226] = { d1m = 0.0029322787 }, -- Divad's Chagrin Mine
[231] = { d1m = 0.0027612072 }, -- Aldunz
[224] = { d1m = 0.0028517083 }, -- Coldrock Diggings
[230] = { d1m = 0.0030540499 }, -- Sandblown Mine
[233] = { d1m = 0.0030633718 }, -- Yldzuun
[774] = { d1m = 0.0073212047 }, -- Shore Cave
[51] = { d1m = 0.0017840399 }, -- Ash'abah Pass
[50] = { d1m = 0.0051321651 }, -- Yokudan Palace
[710] = { d1m = 0.005086359 }, -- Yokudan Palace
[336] = { d1m = 0.0046970627 }, -- Salas En
[776] = { d1m = 0.0071759754 }, -- The Portal Chamber
[553] = { d1m = 0.0046134077 }, -- Kulati Mines
[554] = { d1m = 0.0078632482 }, -- Kulati Mines
[337] = { d1m = 0.0049273408 }, -- Impervious Vault
[728] = { d1m = 0.0105549014 }, -- Magistrate's Basement
[729] = { d1m = 0.013863428 }, -- The Master's Crypt
[775] = { d1m = 0.0078885852 }, -- Rkulftzel
[76] = { d1m = 0.0013746124 }, -- Lost City of the Na-Totambu
[3] = { d1m = 0.0019834415 }, -- Volenfell
[790] = { d1m = 0.0090528074 }, -- Volenfell - Secret Tunnel
[732] = { d1m = 0.0069281904 }, -- Volenfell - The Guardian's Helm
[791] = { d1m = 0.0065574418 }, -- Volenfell - The Guardians Skull
[658] = { d1m = 0.0073043412 }, -- Volenfell - The Eye's Chamber
[659] = { d1m = 0.0099752145 }, -- Volenfell - The Guardian's Orbit
[773] = { d1m = 0.0045457633 }, -- Smuggler King's Tunnel
[734] = { d1m = 0.0052344623 }, -- Suturah's Crypt

-- ============================================================================== 
[256] = { type = ZT_ZONE, d1m = 0.000294604 }, -- Reaper's March
[312] = { type = ZT_SUBZONE, d1m = 0.0023366842 }, -- Rawl'kha
[533] = { type = ZT_SUBZONE, d1m = 0.0014817404 }, -- Dune
[535] = { type = ZT_SUBZONE, d1m = 0.0015664403 }, -- Arenthia
[213] = { type = ZT_NONE, d1m = 0.0046961947 }, -- Khaj Rawlith
[527] = { type = ZT_NONE, d1m = 0.0049653082 }, -- Senalana
[29] = { type = ZT_NONE, d1m = 0.0037155534 }, -- Greenhill Catacombs
[305] = { type = ZT_NONE, d1m = 0.0038845108 }, -- Ren-dro Caverns
[116] = { type = ZT_NONE, d1m = 0.0022069658 }, -- Fort Sphinxmoth
[4] = { type = ZT_NONE, d1m = 0.0024134572 }, -- Rawl'kha Temple
[823] = { type = ZT_NONE, d1m = 0.0048645998 }, -- Rawl'kha Outlaws Refuge
[306] = { type = ZT_NONE, d1m = 0.0029347797 }, -- Moonmont Temple
[302] = { type = ZT_NONE, d1m = 0.0028413782 }, -- Do'Krin Temple
[758] = { type = ZT_NONE, d1m = 0.0029712775 }, -- The Five Finger Dance
[557] = { type = ZT_NONE, d1m = 0.0052097645 }, -- Cleft Rock Cave
[308] = { type = ZT_NONE, d1m = 0.0056267146 }, -- Temple of the Dance
[310] = { type = ZT_NONE, d1m = 0.0014422868 }, -- The Demiplane of Jode
[601] = { type = ZT_NONE, d1m = 0.0019078486 }, -- The Wild Hunt
[589] = { type = ZT_NONE, d1m = 0.0030454762 }, -- Urcelmo's Betrayal
[309] = { type = ZT_NONE, d1m = 0.0045030857 }, -- The Demiplane of Jode
[311] = { type = ZT_NONE, d1m = 0.0029233472 }, -- Den of Lorkhaj
[303] = { type = ZT_NONE, d1m = 0.0024149462 }, -- Halls of Ichor
[558] = { type = ZT_NONE, d1m = 0.0070824956 }, -- Old S'ren-ja Cave
[559] = { type = ZT_NONE, d1m = 0.0081223794 }, -- Rainshadow Cave
[323] = { type = ZT_NONE, d1m = 0.0034749502 }, -- Thibaut's Cairn
[301] = { type = ZT_NONE, d1m = 0.0030427269 }, -- Claw's Strike
[304] = { type = ZT_NONE, d1m = 0.0028622799 }, -- Jode's Light
[210] = { type = ZT_NONE, d1m = 0.0038356397 }, -- Fardir's Folly
[343] = { type = ZT_NONE, d1m = 0.0032292248 }, -- Kuna's Delve
[307] = { type = ZT_NONE, d1m = 0.0032198138 }, -- Weeping Wind Cave
[763] = { type = ZT_NONE, d1m = 0.0174327309 }, -- The Vile Manse
[764] = { type = ZT_NONE, d1m = 0.0175051278 }, -- The Vile Manse
[317] = { type = ZT_NONE, d1m = 0.002110461 }, -- The Vile Manse
[318] = { type = ZT_NONE, d1m = 0.0021430987 }, -- The Vile Manse
[334] = { type = ZT_NONE, d1m = 0.0015694004 }, -- Selene's Web
[997] = { type = ZT_NONE, d1m = 0.0018711862 }, -- Maw of Lorkhaj
[998] = { type = ZT_NONE, d1m = 0.006737295 }, -- Maw of Lorkhaj - Temple Hall
[2271] = { d1m = 0.0027961496 }, -- Shrine of the Golden Eye

-- ============================================================================== 
[125] = { type = ZT_ZONE, d1m = 0.0002438741 }, -- The Rift
[542] = { type = ZT_SUBZONE, d1m = 0.0017322909 }, -- Shor's Stone
[543] = { type = ZT_SUBZONE, d1m = 0.0013857898 }, -- Nimalten
[198] = { type = ZT_SUBZONE, d1m = 0.0017220367 }, -- Riften
[815] = { type = ZT_SEWERS, d1m = 0.0052393002 }, -- Riften Outlaws Refuge
[1784] = { type = ZT_SEWERS, d1m = 0.0037908691 }, -- Riften Ratway Lower
[1753] = { type = ZT_SEWERS, d1m = 0.0037930828 }, -- Riften Ratway
[81] = { type = ZT_MINE, d1m = 0.0057099136 }, -- Lost Prospect
[580] = { type = ZT_MINE, d1m = 0.0042756113 }, -- Lost Prospect
[463] = { type = ZT_CRYPT, d1m = 0.0065409461 }, -- Dragon Cult Temple
[176] = { type = ZT_CAVE, d1m = 0.0025181105 }, -- Trolhetta Cave
[655] = { type = ZT_MINIZONE, d1m = 0.0035982009 }, -- Trolhetta Summit
[460] = { type = ZT_CRYPT, d1m = 0.0047608476 }, -- Fallowstone Vault
[177] = { type = ZT_MINE, d1m = 0.003307916 }, -- Northwind Mine
[325] = { type = ZT_CRYPT, d1m = 0.0057723171 }, -- Vaults of Vernim
[1847] = { type = ZT_CRYPT, d1m = 0.0038340822 }, -- Nimalten Barrow
[464] = { type = ZT_CRYPT, d1m = 0.0039115836 }, -- Nimalten Barrow
[465] = { type = ZT_CRYPT, d1m = 0.0082549394 }, -- Nimalten Barrow
[509] = { type = ZT_CRYPT, d1m = 0.0036732281 }, -- Taarengrav Barrow
[218] = { type = ZT_CAVE, d1m = 0.0026364788 }, -- Pinepeak Caverns
[590] = { type = ZT_MINIZONE, d1m = 0.0025836334 }, -- Arcwind Point

[214] = { type = ZT_DELVE, d1m = 0.0032323222 }, -- Faldar's Tooth
[703] = { type = ZT_DELVE, d1m = 0.0036234237 }, -- Broken Helm Hollow
[169] = { type = ZT_DELVE, d1m = 0.0047350886 }, -- Avanchnzel
[254] = { type = ZT_DELVE, d1m = 0.0052515599 }, -- Fort Greenwall
[265] = { type = ZT_DELVE, d1m = 0.0031962331 }, -- Snapleg Cave
[211] = { type = ZT_DELVE, d1m = 0.0043196203 }, -- Shroud Hearth Barrow
[142] = { type = ZT_DUNGEON, d1m = 0.001013521 }, -- The Lion's Den

--  ============================================================================== 
[1555] = { type = ZT_ZONE, d1m = 0.0002062994 }, -- Northern Elsweyr
[1576] = { type = ZT_SUBZONE, d1m = 0.0015244612 }, -- Rimmen
[1591] = { type = ZT_SUBZONE, d1m = 0.0023562885 }, -- Riverhold
[1594] = { type = ZT_SUBZONE, d1m = 0.0023562885 }, -- Riverhold - Battle
[1663] = { type = ZT_SUBZONE, d1m = 0.0022089556 }, -- The Stitches
[1673] = { type = ZT_DELVE, d1m = 0.0015927010 }, -- Desert Wind Caverns
[1640] = { type = ZT_NONE, d1m = 0.0015828039 }, -- Desert Wind Caverns 2
[1662] = { type = ZT_NONE, d1m = 0.0015960654 }, -- Desert Wind Caverns 3
[1595] = { type = ZT_DELVE, d1m = 0.0018650693 }, -- Abode of Ignominy
[1616] = { type = ZT_DELVE, d1m = 0.0022569323 }, -- Predator Mesa
[1590] = { type = ZT_DELVE, d1m = 0.0022419495 }, -- Tomb of the Serpents
[1626] = { type = ZT_DELVE, d1m = 0.0019957223 }, -- The Tangle
[1608] = { type = ZT_DELVE, d1m = 0.0019909050 }, -- Darkpool Mine
[1636] = { type = ZT_DUNGEON, d1m = 0.0015649902 }, -- Orcrest Main
[1637] = { type = ZT_DUNGEON, d1m = 0.0015431345 }, -- Orcrest Red Senche Alley
[1638] = { type = ZT_DUNGEON, d1m = 0.0048273742 }, -- Orcrest Sewers
[1639] = { type = ZT_DUNGEON, d1m = 0.0013617432 }, -- Rimmen Necropolis
[1660] = { type = ZT_CAVE, d1m = 0.0033314688 }, -- Smuggler's Hideout
[1628] = { type = ZT_CAVE, d1m = 0.0044595195 }, -- Merryvale Sugar Farm Caves
[1577] = { type = ZT_CRYPT, d1m = 0.0032897486 }, -- Tenarr Zalviit Ossuary
[1627] = { type = ZT_CRYPT, d1m = 0.0032953164 }, -- Tenarr Zalviit Warrens
[1586] = { type = ZT_CRYPT, d1m = 0.0027149487 }, -- Hakoshae Tombs
[1641] = { type = ZT_CRYPT, d1m = 0.0135 }, -- Desert Wind Caverns - Grand Adept Chambers
[1656] = { type = ZT_CRYPT, d1m = 0.009 }, -- Desert Wind Temple - Tunnel
[1642] = { type = ZT_CRYPT, d1m = 0.009 }, -- Desert Wind Temple
[1585] = { type = ZT_NONE, d1m = 0.00515 }, -- Rimmen Palace Courtyard
[1570] = { type = ZT_SEWERS, d1m = 0.0030699783 }, -- Rimmen Palace Recesses
[1571] = { type = ZT_CRYPT, d1m = 0.0046104343 }, -- Rimmen Palace Crypts
[1584] = { type = ZT_NONE, d1m = 0.0059270981 }, -- Rimmen Palace
[1632] = { type = ZT_CAVE, d1m = 0.0033866511 }, -- Sugar-Slinger's Den Upper
[837] = { type = ZT_CAVE, d1m = 0.0032998854 }, -- Sugar-Slinger's Den Lower
[1617] = { type = ZT_MINE, d1m = 0.0020049762 }, -- Sleepy Senche Mine
[1625] = { type = ZT_COSMIC, d1m = 0.0030382262 }, -- Arum-Khal's Realm
[1624] = { type = ZT_CRYPT, d1m = 0.002594012 }, -- Hidden Moon Crypts
[1587] = { type = ZT_TEMPLE, d1m = 0.0016733064 }, -- Dov-Vahl Shrine
[1644] = { type = ZT_CRYPT, d1m = 0.0057 }, -- Sepulcher of Mischance Upper
[1645] = { type = ZT_CRYPT, d1m = 0.0082651379 }, -- Sepulcher of Mischance 1
[1646] = { type = ZT_CRYPT, d1m = 0.0085895719 }, -- Sepulcher of Mischance 2
[1647] = { type = ZT_CRYPT, d1m = 0.0083943279 }, -- Sepulcher of Mischance 3
[1648] = { type = ZT_CRYPT, d1m = 0.0082902827 }, -- Sepulcher of Mischance 4
[1671] = { type = ZT_CRYPT, d1m = 0.0058244348 }, -- Sepulcher of Mischance 5
[1592] = { type = ZT_TEMPLE, d1m = 0.00305 }, -- Shadow Dance Temple Entrance
[1593] = { type = ZT_TEMPLE, d1m = 0.0022676817 }, -- Shadow Dance Temple
[1659] = { type = ZT_TEMPLE, d1m = 0.010851484 }, -- Vault of Heavenly Scourge
[1667] = { type = ZT_TEMPLE, d1m = 0.0021108554 }, -- Moon Gate of Anequina
[1668] = { type = ZT_TEMPLE, d1m = 0.0015900327 }, -- Jode's Core

--  ============================================================================== 
[9] = { type = ZT_ZONE, d1m = 0.0002828988 }, -- Grahtwood
[445] = { type = ZT_SUBZONE, d1m = 0.0012880952 }, -- Elden Root
[450] = { type = ZT_INDOOR, d1m = 0.0044588132 }, -- Elden Root Ground Level
[446] = { type = ZT_INDOOR, d1m = 0.0053404265 }, -- Elden Root Upper Floor
[571] = { type = ZT_INDOOR, d1m = 0.0053849253 }, -- Elden Root Fighters Guild
[449] = { type = ZT_INDOOR, d1m = 0.0053373751 }, -- Elden Root Mage Guild
[451] = { type = ZT_INDOOR, d1m = 0.0053414254 }, -- Elden Root Throne Room
[536] = { type = ZT_SUBZONE, d1m = 0.0027440101 }, -- Redfur Trading Post
[512] = { type = ZT_SUBZONE, d1m = 0.0013775114 }, -- Haven
[414] = { type = ZT_DELVE, d1m = 0.0041934484 }, -- Wormroot Depths
[393] = { type = ZT_DELVE, d1m = 0.0039592054 }, -- Vinedeath Cave
[396] = { type = ZT_DELVE, d1m = 0.0034181370 }, -- Burroot Kwama Mine
[395] = { type = ZT_DELVE, d1m = 0.0033485392 }, -- Mobar Mine
[394] = { type = ZT_DELVE, d1m = 0.0033866176 }, -- The Scuttle Pit
[404] = { type = ZT_DELVE, d1m = 0.0042121438 }, -- Ne Salas
[283] = { type = ZT_DUNGEON, d1m = 0.0027290363 }, -- Root Sunder Ruins

[1717] = { d1m = 0.0025323616 }, -- Lair of Maarselok - Tenmar Mountain Valley
[1718] = { d1m = 0.0021091002 }, -- Lair of Maarselok - Path of the Rising Sun
[1720] = { d1m = 0.0025202426 }, -- Lair of Maarselok - Ruins of Magrus's Ascent
[1722] = { d1m = 0.0027316486 }, -- Lair of Maarselok - Ruins of Magrus's Ascent
[1723] = { d1m = 0.0018964983 }, -- Lair of Maarselok - Noon Ray's Path
[1724] = { d1m = 0.0018995892 }, -- Lair of Maarselok - Azureblight Summit


[2270] = { d1m = 0.0032245275 }, -- Emerald Glyphic Vault
[2348] = { d1m = 0.0032221756 }, -- Emerald Glyphic Vault

--  ============================================================================== 
[108] = { type = ZT_ZONE, d1m = 0.0016754935 }, -- Eyevea

--  ============================================================================== 
[7] = { type = ZT_ZONE, d1m = 0.0002737997 }, -- Stonefalls
[24] = { type = ZT_SUBZONE, d1m = 0.0013623396 }, -- Davon's Watch
[510] = { type = ZT_SUBZONE, d1m = 0.0016319819 }, -- Kragenmoor
[511] = { type = ZT_SUBZONE, d1m = 0.0012971857 }, -- Ebonheart
[814] = { d1m = 0.0052090732 }, -- Davon's Watch Outlaws Refuge
[70] = { d1m = 0.003079081 }, -- Ash Mountain
[72] = { d1m = 0.0019906754 }, -- Crow's Wood
[86] = { d1m = 0.0047630319 }, -- Fort Arand Dungeons
[90] = { d1m = 0.0026485507 }, -- Inner Sea Armature
[91] = { d1m = 0.0043910694 }, -- Iliath Temple Mines
[92] = { d1m = 0.0038203791 }, -- Heimlyn Keep Reliquary
[93] = { d1m = 0.0042698381 }, -- House Indoril Crypt
[94] = { d1m = 0.0034943608 }, -- House Dres Crypts
[95] = { d1m = 0.0059496041 }, -- Coral Heart Chamber
[97] = { d1m = 0.0035764946 }, -- Hightide Hollow
[105] = { d1m = 0.0024072157 }, -- Cheesemonger's Hollow
[109] = { d1m = 0.0061535384 }, -- Fort Virak Ruin
[110] = { d1m = 0.0026132299 }, -- Softloam Cavern
[112] = { d1m = 0.002552828 }, -- Emberflint Mine
[113] = { d1m = 0.002464829 }, -- Sheogorath's Tongue
[114] = { d1m = 0.0031386988 }, -- Mephala's Nest
[482] = { d1m = 0.0057728354 }, -- The Worm's Retreat
[602] = { d1m = 0.0033442459 }, -- Tormented Spire
[717] = { d1m = 0.0055147074 }, -- Starved Planes
[719] = { d1m = 0.0088780445 }, -- Crow's Wood
[766] = { d1m = 0.0019277766 }, -- Charred Ridge
[786] = { d1m = 0.0020319004 }, -- Tormented Spire

--  ============================================================================== 
[143] = { type = ZT_ZONE, d1m = 0.0002456598 }, -- Auridon
[243] = { type = ZT_SUBZONE, d1m = 0.0012199237 }, -- Vulkhel Guard
[545] = { type = ZT_SUBZONE, d1m = 0.0014369003 }, -- Skywatch
[540] = { type = ZT_SUBZONE, d1m = 0.0014832046 }, -- Firsthold
[181] = { type = ZT_DELVE, d1m = 0.0029342177 }, -- Wansalen
[179] = { type = ZT_DELVE, d1m = 0.0037825837 }, -- Ondil
[182] = { type = ZT_DELVE, d1m = 0.0038365942 }, -- Mehrunes' Spite
[186] = { type = ZT_DELVE, d1m = 0.0025004844 }, -- Entila's Folly
[178] = { type = ZT_DELVE, d1m = 0.0029775446 }, -- Del's Claim
[180] = { type = ZT_DELVE, d1m = 0.0031039448 }, -- Bewan
[268] = { type = ZT_DUNGEON, d1m = 0.0018180335 }, -- Toothmaul Gully

--  ============================================================================== 
[13] = { type = ZT_ZONE, d1m = 0.0002437870 }, -- Deshaan
[205] = { type = ZT_SUBZONE, d1m = 0.0011725358 }, -- Mournhold
[537] = { type = ZT_SUBZONE, d1m = 0.0020445189 }, -- Narsis
[82] = { d1m = 0.0049169536 }, -- Reservoir of Souls
[115] = { d1m = 0.0029387062 }, -- Forgotten Crypts
[117] = { d1m = 0.0030121652 }, -- Eidolon's Hollow
[119] = { d1m = 0.0160577814 }, -- Lady Llarel's Shelter
[120] = { d1m = 0.0033841259 }, -- The Triple Circle Mine
[121] = { d1m = 0.003801128 }, -- Lower Bthanual
[122] = { d1m = 0.0033202889 }, -- Taleon's Crag
[123] = { d1m = 0.004297208 }, -- Knife Ear Grotto
[124] = { d1m = 0.0040723323 }, -- The Corpse Garden
[126] = { d1m = 0.0029097984 }, -- Deepcrag Den
[127] = { d1m = 0.0032769111 }, -- Mzithumz
[128] = { d1m = 0.0042786697 }, -- Tribunal Temple
[129] = { d1m = 0.0059835669 }, -- Shad Astula Underhalls
[131] = { d1m = 0.003243115 }, -- Tal'Deic Crypts
[191] = { d1m = 0.0030918162 }, -- Bthanual
[392] = { d1m = 0.0031939756 }, -- Mournhold Sewers
[547] = { d1m = 0.0028397064 }, -- Obsidian Gorge
[569] = { d1m = 0.0029904501 }, -- Quarantine Serk Catacombs
[714] = { d1m = 0.0105795429 }, -- The Shrine of St.Veloth
[715] = { d1m = 0.008858271 }, -- Apothacarium
[747] = { d1m = 0.0077445433 }, -- Vale of the Ghost Snake
[819] = { d1m = 0.0035307235 }, -- Mournhold Outlaws Refuge


--  ============================================================================== 
[61] = { type = ZT_ZONE, d1m = 0.0002429406 }, -- Eastmarch
[160] = { type = ZT_SUBZONE, d1m = 0.001828079 }, -- Windhelm
[578] = { type = ZT_SUBZONE, d1m = 0.0019801475 }, -- Fort Amol
[1781] = { type = ZT_INDOOR, d1m = 0.0083289884 }, -- Palace Of Kings
[1788] = { type = ZT_INDOOR, d1m = 0.0083866702 }, -- Palace Of Kings Dungeon
[1789] = { type = ZT_INDOOR, d1m = 0.0065098086 }, -- Palace of Kings Inner Chamber
[1794] = { type = ZT_INDOOR, d1m = 0.008328403 }, -- Palace Of Kings

[140] = { d1m = 0.0019804589 }, -- Hall of the Dead
[153] = { d1m = 0.0030924386 }, -- Fort Morvunskar
[154] = { d1m = 0.003515375 }, -- Bonestrewn Crest
[156] = { d1m = 0.0029977971 }, -- Lost Knife Cave
[157] = { d1m = 0.0028553574 }, -- Mistwatch Creavase - Ice Cave
[158] = { d1m = 0.0040034799 }, -- Cragwallow
[159] = { d1m = 0.0017165238 }, -- Mzulft
[163] = { d1m = 0.0037132925 }, -- The Chill Hollow
[164] = { d1m = 0.0031417291 }, -- Icehammer's Vault
[165] = { d1m = 0.0029903774 }, -- Old Sord's Cave
[166] = { d1m = 0.004134479 }, -- The Frigid Grotto
[167] = { d1m = 0.0029870452 }, -- The Bastard's Tomb
[168] = { d1m = 0.003830362 }, -- Stormcrag Crypt
[171] = { d1m = 0.0072137645 }, -- Giant's Run
[324] = { d1m = 0.0037470331 }, -- Wittestadr Crypts
[461] = { d1m = 0.0051324915 }, -- Mistwatch Crevasse
[462] = { d1m = 0.0057218455 }, -- Hall of Trials
[1607] = { d1m = 0.0026806485 }, -- Frostvault - Iceflow Rift
[2387] = { d1m = 0.0030623617 }, -- Mistwatch Creavase - Ice Cave Upper

--  ============================================================================== 
[1887] = { type = ZT_ZONE, d1m = 0.0001989522 }, -- Blackwood
[2018] = { type = ZT_SUBZONE, d1m = 0.0024283691 }, -- Gideon
[1940] = { type = ZT_SUBZONE, d1m = 0.0020021955 }, -- Leyawiin
[2000] = { type = ZT_DUNGEON, d1m = 0.000729305 }, -- Atoll of Immolation
[2053] = { d1m = 0.0049349434 }, -- Atoll of Immolation
[2054] = { d1m = 0.0033802343 }, -- Atoll of Immolation
[1939] = { d1m = 0.0020331409 }, -- Arpenia
[2030] = { d1m = 0.0020468821 }, -- Arpenia
[2031] = { d1m = 0.0020626755 }, -- Arpenia
[2032] = { d1m = 0.002046325 }, -- Arpenia
[1979] = { d1m = 0.0050946151 }, -- Doomvault Porcixid
[2057] = { d1m = 0.0023088193 }, -- Doomvault Porcixid
[2058] = { d1m = 0.0047740369 }, -- Doomvault Porcixid
[2059] = { d1m = 0.0050166325 }, -- Doomvault Porcixid
[2060] = { d1m = 0.0018254849 }, -- Doomvault Porcixid
[2061] = { d1m = 0.0035589465 }, -- Doomvault Porcixid
[2063] = { d1m = 0.0052202363 }, -- Doomvault Porcixid
[2064] = { d1m = 0.003637248 }, -- Doomvault Porcixid
[1977] = { d1m = 0.002033495 }, -- Vunalk
[2062] = { d1m = 0.0021329104 }, -- Vunalk
[1945] = { d1m = 0.0020052452 }, -- Xi-Tsei
[1946] = { d1m = 0.0027023436 }, -- Xi-Tsei
[1930] = { d1m = 0.0015113201 }, -- Bloodrun Cave
[1935] = { d1m = 0.001355822 }, -- Undertow Cavern
[1943] = { d1m = 0.0027006307 }, -- The Silent Halls
[1958] = { d1m = 0.0021283035 }, -- The Silent Halls
[1959] = { d1m = 0.0021278131 }, -- The Silent Halls
[2055] = { d1m = 0.0045015374 }, -- The Silent Halls
[2056] = { d1m = 0.007925431 }, -- The Silent Halls
[2077] = { d1m = 0.0043622797 }, -- The Silent Halls
[1985] = { d1m = 0.0012745276 }, -- Zenithar's Abbey - Bazaar
[1986] = { d1m = 0.0013033735 }, -- Zenithar's Abbey - Grounds
[1987] = { d1m = 0.0012828589 }, -- Zenithar's Abbey - Trade Port
[1988] = { d1m = 0.001323075 }, -- Zenithar's Abbey - Cloister
[1989] = { d1m = 0.0012718378 }, -- Zenithar's Abbey - Bazaar 2
[2022] = { d1m = 0.0050347943 }, -- Zenithar's Abbey - Adytum
[1978] = { d1m = 0.0018930139 }, -- Deepscorn Hollow
[1984] = { d1m = 0.0030472632 }, -- Tidewater Cave
[1974] = { d1m = 0.0018634321 }, -- Veyond
[1975] = { d1m = 0.0039554776 }, -- Veyond
[1976] = { d1m = 0.0034043298 }, -- Veyond
[1981] = { d1m = 0.0028738777 }, -- Xal Irasotl
[1934] = { d1m = 0.0021617982 }, -- Glenbridge Xanmeer
[2016] = { d1m = 0.0067294087 }, -- Stonewastes Keep
[1937] = { d1m = 0.0019352295 }, -- Welke
[2033] = { d1m = 0.0034761736 }, -- Welke
[2034] = { d1m = 0.0039690849 }, -- Welke
[1991] = { d1m = 0.0022266789 }, -- Doomvault Vulpinaz Upper Level
[1992] = { d1m = 0.0021912921 }, -- Doomvault Vulpinaz Mid Level
[1993] = { d1m = 0.002213962 }, -- Doomvault Vulpinaz Lower Level
[1994] = { d1m = 0.0022781831 }, -- Doomvault Vulpinaz Anchor Chamber
[2004] = { d1m = 0.0012192158 }, -- Ancient City of Rockgrove
[1950] = { d1m = 0.0029191394 }, -- Borderwatch Courtyard
[1951] = { d1m = 0.0056156874 }, -- Borderwatch Ayleid Ruins
[1952] = { d1m = 0.0044587318 }, -- Borderwatch Crypt
[1953] = { d1m = 0.0050838434 }, -- Borderwatch Keep
[1954] = { d1m = 0.0034428056 }, -- Borderwatch Sewers
[1998] = { d1m = 0.0049401918 }, -- Leyawiin Outlaws Refuge
[1999] = { d1m = 0.0049337819 }, -- Leyawiin Outlaws Refuge
[2017] = { d1m = 0.0049179387 }, -- Leyawiin Outlaws Refuge
[2013] = { d1m = 0.0041843465 }, -- Twyllbek Ruins
[2014] = { d1m = 0.0042013201 }, -- Twyllbek Ruins
[1969] = { d1m = 0.0052805305 }, -- Leyawiin Castle
[1970] = { d1m = 0.0053467428 }, -- Leyawiin Castle
[1972] = { d1m = 0.0019269423 }, -- Leyawiin Castle Courtyard
[1938] = { d1m = 0.0014063811 }, -- Doomvault Capraxus
[1948] = { d1m = 0.0026133223 }, -- Vandacia's Deadlands Keep
[1949] = { d1m = 0.0024895378 }, -- Vandacia's Deadlands Keep
[1941] = { d1m = 0.0029222213 }, -- Xynaa's Sanctuary
[1942] = { d1m = 0.0015751335 }, -- Xynaa's Sanctuary - Deadlands: The Ashen Forest
[2065] = { d1m = 0.008412701 }, -- Xynaa's Sanctuary - White Gold Tower Throne Room
[1982] = { d1m = 0.0022993731 }, -- Fort Redmane
[1983] = { d1m = 0.0018153067 }, -- Fort Redmane

-- ===============================================================================
[10] = { type = ZT_ZONE, d1m = 0.0003210387 }, -- Rivenspire
[85] = { type = ZT_SUBZONE, d1m = 0.002072414 }, -- Shornhelm
[812] = { type = ZT_SEWERS, d1m = 0.0086449157 }, -- Shornhelm Outlaws Refuge
[513] = { type = ZT_SUBZONE, d1m = 0.0020501388 }, -- Northpoint
[528] = { type = ZT_SUBZONE, d1m = 0.0033063168 }, -- Hoarfrost Downs
[225] = { d1m = 0.0033539153 }, -- Crestshade Mine
[204] = { d1m = 0.0038841174 }, -- Erokii Ruins
[216] = { d1m = 0.00487429 }, -- Flyleaf Catacombs
[244] = { d1m = 0.0032803593 }, -- Hildune's Secret Refuge
[200] = { d1m = 0.00395449 }, -- Orc's Finger Ruins
[220] = { d1m = 0.0049022633 }, -- Tribulation Crypt
[42] = { d1m = 0.0034371911 }, -- Obsidian Scar
[151] = { d1m = 0.0021397545 }, -- Crypt of Hearts I
[1154] = { d1m = 0.0021470868 }, -- Crypt of Hearts II
[2120] = { d1m = 0.0009764159 }, -- Shipwright's Regret
[2157] = { d1m = 0.0042596374 }, -- Shipwright's Regret - Frigid Cavern
[788] = { d1m = 0.0041946511 }, -- Fevered Mews
[789] = { d1m = 0.0101709289 }, -- Fevered Mews
[59] = { d1m = 0.0031010404 }, -- Doomcrag Shrouded Pass
[476] = { d1m = 0.0041512739 }, -- Shadowfate Cavern
[480] = { d1m = 0.0039229956 }, -- Lorkrata Ruins
[481] = { d1m = 0.0040170412 }, -- Lorkrata Ruins
[647] = { d1m = 0.004772374 }, -- Edrald Undercroft
[2] = { d1m = 0.0032313591 }, -- Edrald Undercroft
[478] = { d1m = 0.0049754363 }, -- Breagha-Fin
[479] = { d1m = 0.0042564525 }, -- Breagha-Fin
[560] = { d1m = 0.0046712024 }, -- Shrouded Pass - Varlasel
[477] = { d1m = 0.0052908156 }, -- Shrouded Pass - Chamber of the Stone Guardian
[57] = { d1m = 0.0083758007 }, -- Doomcrag
[58] = { d1m = 0.0079444878 }, -- Doomcrag
[442] = { d1m = 0.0111099251 }, -- Doomcrag

-- ===============================================================================
[667] = { type = ZT_ZONE, d1m = 0.0002783857 }, -- Wrothgar
[895] = { type = ZT_SUBZONE, d1m = 0.0014479954 }, -- Orsinium
[954] = { type = ZT_SUBZONE, d1m = 0.0027146756 }, -- Morkul Stronghold

-- ===============================================================================
[1864] = { type = ZT_ZONE, d1m = 0.0010983753 }, -- Grayhome
[1866] = { type = ZT_CASTLE, d1m = 0.0036039109 }, -- Castle Grayhome
[1868] = { type = ZT_CASTLE, d1m = 0.0036449523 }, -- Castle Grayhome Upper

-- ===============================================================================
[20] = { type = ZT_ZONE, d1m = 0.0002999195 }, -- Bangkorai
[360] = { type = ZT_SUBZONE, d1m = 0.0013780177 }, -- Hallin's Stand
[84] = { type = ZT_SUBZONE, d1m = 0.00173892 }, -- Evermore
[245] = { type = ZT_DELVE, d1m = 0.0031308847 }, -- Rubble Butte

-- ===============================================================================
[1126] = { type = ZT_ZONE, d1m = 0.000278673 }, -- Craglorn
[1131] = { type = ZT_SUBZONE, d1m = 0.0019815171 }, -- Belkarth
[1132] = { type = ZT_SUBZONE, d1m = 0.0028417065 }, -- Dragonstar

-- ===============================================================================
[1814] = { type = ZT_ZONE, d1m = 0.0003335912 }, -- The Reach
[1858] = { type = ZT_SUBZONE, d1m = 0.0027057942 }, -- Markarth

-- ===============================================================================
-- Cannot sync distances with subzone
[1719] = { type = ZT_ZONE, d1m = 0.0002401136 }, -- Western Skyrim
[1773] = { type = ZT_SUBZONE, d1m = 0.0021761623 }, -- Solitude


-- ===============================================================================
[74] = { type = ZT_ZONE, d1m = 0.0006736522 }, -- Bleakrock Isle
[8] = { type = ZT_SUBZONE, d1m = 0.0022367409 }, -- Bleakrock Village
[87] = { d1m = 0.0031016467 }, -- Orkey's Hollow
[88] = { d1m = 0.0036230893 }, -- Hozzin's Folly
[89] = { d1m = 0.0022965229 }, -- Last Rest
[726] = { d1m = 0.0079384916 }, -- Skyshroud Barrow

-- ===============================================================================
[1747] = { type = ZT_UNDERWORLD, d1m = 0.0003791088 }, -- Blackreach: Greymoor Caverns
[1850] = { type = ZT_UNDERWORLD, d1m = 0.0007311898 }, -- Blackreach: Arkthzand Cavern
[1748] = { type = ZT_UNDERWORLD, d1m = 0.001600429 }, -- Blackreach: Mzark Cavern
[2469] = { type = ZT_RUIN, d1m = 0.0067424687 }, -- Blackreach: Mzark Cavern - Kagalthar Ruins

-- ===============================================================================
[1060] = { type = ZT_ZONE, d1m = 0.0002169291 }, -- Vvardenfell
[1287] = { type = ZT_SUBZONE, d1m = 0.0012296628 }, -- Vivec City
[1290] = { type = ZT_SUBZONE, d1m = 0.0022589554 }, -- Balmora
[1288] = { type = ZT_SUBZONE, d1m = 0.0021236292 }, -- Sadrith Mora
[1276] = { type = ZT_DUNGEON, d1m = 0.0016598261 }, -- The Forgotten Wastes
[1279] = { type = ZT_DUNGEON, d1m = 0.0052680142 }, -- The Forgotten Wastes - Kora Dur
[1277] = { type = ZT_DUNGEON, d1m = 0.0028944653 }, -- The Forgotten Wastes - Caverns of Kogoruhn
[1278] = { type = ZT_DUNGEON, d1m = 0.003716386 }, -- The Forgotten Wastes - Forgotten Depths
[1280] = { type = ZT_DUNGEON, d1m = 0.0070284756 }, -- The Forgotten Wastes - Drinith Ancestral Tomb
[1310] = { d1m = 0.0056868659 }, -- Nchuleftingth Approach
[1311] = { d1m = 0.0052882871 }, -- Nchuleftingth Approach
[1312] = { d1m = 0.0018256001 }, -- Nchuleftingth Approach
[1314] = { d1m = 0.0018239685 }, -- Nchuleftingth Ruins
[1315] = { d1m = 0.0025810991 }, -- Nchuleftingth Lavaworks
[1316] = { d1m = 0.0025483311 }, -- Nchuleftingth Lavaworks
[1317] = { d1m = 0.0036120221 }, -- Nchuleftingth Core
[1318] = { d1m = 0.0044322819 }, -- Nchuleftingth Sanctum

[1300] = { type = ZT_DELVE, d1m = 0.0030112466 }, -- Pulk
[1161] = { type = ZT_DELVE, d1m = 0.0030347234 }, -- Pulk

[1157] = { d1m = 0.0025280069 }, -- Khartag Point
[2141] = { d1m = 0.0026582831 }, -- Ascendant Order Hideout
[1158] = { d1m = 0.0054542236 }, -- Ashalmawia
[1274] = { d1m = 0.0033443609 }, -- Ashalmawia - Sunken Vaults
[1275] = { d1m = 0.0032723854 }, -- Ashalmawia - Sunken Vaults
[1159] = { d1m = 0.0019376823 }, -- Zainsipilu
[1160] = { d1m = 0.0021469062 }, -- Matus-Akin Egg Mine
[1162] = { d1m = 0.0052054133 }, -- Nchuleft
[1283] = { d1m = 0.0038986585 }, -- Nchuleft Depths
[1207] = { d1m = 0.0084638152 }, -- Veloth Ancestral Tomb
[1269] = { d1m = 0.0028972226 }, -- Veloth Ancestral Tomb - Undertomb
[1270] = { d1m = 0.0050675684 }, -- Veloth Ancestral Tomb - Tomb of the Matriarch
[1208] = { d1m = 0.0080064723 }, -- Dreloth Ancestral Tomb
[1209] = { d1m = 0.0059895737 }, -- Hleran Ancestral Tomb
[1210] = { d1m = 0.0024850855 }, -- Inanius Egg mine
[1211] = { d1m = 0.0038432977 }, -- Ashurnibibi
[1212] = { d1m = 0.0060382791 }, -- Andrano Ancestral Tomb
[1213] = { d1m = 0.0030339915 }, -- Galom Daeus
[1297] = { d1m = 0.0030269218 }, -- Galom Daeus
[1214] = { d1m = 0.002677509 }, -- Zalkin-Sul Egg Mine
[1215] = { d1m = 0.0041893701 }, -- Mzanchend
[1216] = { d1m = 0.0040338036 }, -- Mzanchend
[1219] = { d1m = 0.0039280649 }, -- Vassamsi Mine
[1289] = { d1m = 0.0038927788 }, -- Vassamsi Mine
[1220] = { d1m = 0.0146980136 }, -- Palace Receiving Room
[1221] = { d1m = 0.0148344535 }, -- Lord Vivec's Chambers
[1222] = { d1m = 0.0176910984 }, -- Library of Vivec
[1224] = { d1m = 0.0180949353 }, -- Archcanon's Office
[1225] = { d1m = 0.016950143 }, -- Hall of Justice
[1230] = { d1m = 0.010282003 }, -- Saint Olms Plaza
[1231] = { d1m = 0.0089233212 }, -- Saint Olms Waistworks
[1232] = { d1m = 0.0102099575 }, -- Saint Olms Square
[1233] = { d1m = 0.0085456392 }, -- Saint Olms Guild Halls
[1235] = { d1m = 0.0092314334 }, -- Saint Delyn Waistworks
[1236] = { d1m = 0.0072117797 }, -- Saint Delyn Square
[1237] = { d1m = 0.0097252155 }, -- Saint Delyn Guild Halls
[1238] = { d1m = 0.0111993364 }, -- Saint Delyn's Inn
[1239] = { d1m = 0.0063313682 }, -- Skar
[1240] = { d1m = 0.0026802722 }, -- Dreudurai Glass Mine
[1241] = { d1m = 0.0036586047 }, -- Zaintiraris
[1242] = { d1m = 0.0039125247 }, -- Arkngthunch-Sturdumz
[1243] = { d1m = 0.0089712239 }, -- Library of Andule
[1244] = { d1m = 0.0078149599 }, -- Library of Andule
[1245] = { d1m = 0.008054406 }, -- Vivec City Outlaws Refuge
[1246] = { d1m = 0.0022875366 }, -- Vassir-Didanat Mine
[1247] = { d1m = 0.0073560348 }, -- Vassir-Didanat Mine
[1248] = { d1m = 0.001478285 }, -- Firemoth Island
[1249] = { d1m = 0.0043489312 }, -- Shulk Ore Mine
[1250] = { d1m = 0.0031926093 }, -- Ashimanu Cave
[1251] = { d1m = 0.0032747347 }, -- Ashimanu Cave
[1252] = { d1m = 0.003008768 }, -- Pinsun
[1253] = { d1m = 0.0049058037 }, -- Tusenend
[1254] = { d1m = 0.006240274 }, -- Ramimilk
[1255] = { d1m = 0.0069493357 }, -- Kudanat Mine
[1256] = { d1m = 0.0038041203 }, -- Kaushtarari
[1257] = { d1m = 0.00370236 }, -- Kaushtarari
[1258] = { d1m = 0.0118474165 }, -- Barilzar's Tower
[1259] = { d1m = 0.010477081 }, -- Cavern of the Incarnate
[1260] = { d1m = 0.0036207937 }, -- Mallapi Cave
[1261] = { d1m = 0.0028442279 }, -- Bal Ur
[1262] = { d1m = 0.0054564298 }, -- Redoran Garrison
[1263] = { d1m = 0.0054851078 }, -- Redoran Garrison
[1264] = { d1m = 0.0110280456 }, -- Redoran Garrison
[1271] = { d1m = 0.0016064693 }, -- Gnisis Egg Mine
[1272] = { d1m = 0.0105180834 }, -- Bal Fell
[1273] = { d1m = 0.0079994035 }, -- Prison of Xykenaz
[2155] = { d1m = 0.0018940765 }, -- Sareloth Grotto
[2143] = { d1m = 0.0016458992 }, -- Sword's Rest Isle
[2144] = { d1m = 0.0088666401 }, -- Sword's Rest Keep
[2145] = { d1m = 0.0046556164 }, -- Sword's Rest Keep Basement

-- ===============================================================================
[2274] = { type = ZT_ZONE, d1m = 0.0003372194 }, -- Telvanni Peninsula
[2343] = { type = ZT_SUBZONE, d1m = 0.0014023653 }, -- Necrom
[2386] = { type = ZT_SUBZONE, d1m = 0.0029882703 }, -- Ald Isra
[2305] = { d1m = 0.0019800289 }, -- Anchre Egg Mine
[2292] = { d1m = 0.0020716972 }, -- Camonnaruhn
[2302] = { d1m = 0.0014599752 }, -- Gorne
[2303] = { d1m = 0.0124699323 }, -- Gorne - Dreynis's Den
[2333] = { d1m = 0.0150975068 }, -- Sanity's Edge - Tower
[2372] = { d1m = 0.0016992784 }, -- Sanity's Edge - Vanton's Nightmare
[2293] = { d1m = 0.0022522073 }, -- Tel Dreloth Caverns
[2397] = { d1m = 0.0028723323 }, -- Tel Dreloth Isolation Tower Cellar
[2403] = { d1m = 0.0023770486 }, -- Tel Dreloth Caverns
[2401] = { d1m = 0.002353448 }, -- Tel Dreloth
[2283] = { d1m = 0.0031521446 }, -- Sailenmora Crypts
[2300] = { d1m = 0.0022446061 }, -- Kemel-Ze - Antechamber
[2301] = { d1m = 0.0027397571 }, -- Kemel-Ze - Outer Laborotory
[2282] = { d1m = 0.0022480131 }, -- Old Sailenmora Outpost
[2299] = { d1m = 0.0049204902 }, -- Alavelis Glass Mine
[2285] = { d1m = 0.0051013381 }, -- Tel Rendys
[2284] = { d1m = 0.0038030086 }, -- Tel Baro Cavern
[2385] = { d1m = 0.0051144395 }, -- Necrom Underways
[2402] = { d1m = 0.0039091122 }, -- Necrom Outlaws Refuge
[2342] = { d1m = 0.0038810903 }, -- Necrom Outlaws Refuge
[2347] = { d1m = 0.0034860473 }, -- Necrom Necropolis
[2315] = { d1m = 0.0032878414 }, -- Necropolis Catacombs
[2316] = { d1m = 0.0035975657 }, -- Tel Huulen Assembly Halls
[2396] = { d1m = 0.0035236569 }, -- Tel Huulen Assembly Halls
[2406] = { d1m = 0.0030488181 }, -- Shrine of Vaermina

-- ===============================================================================
[75] = { type = ZT_ZONE, d1m = 0.0007797666 }, -- Bal Foyen
[56] = { type = ZT_SUBZONE, d1m = 0.0032823159 }, -- Dhalmora
[713] = { d1m = 0.0090123185 }, -- Smuggler's Tunnel

-- ===============================================================================
[1997] = { type = ZT_ZONE, d1m = 0.0020926431 }, -- Isle of Balfiera
[2041] = { type = ZT_INDOOR, d1m = 0.0042058361 }, -- Balfiera Ruins
[1996] = { type = ZT_INDOOR, d1m = 0.004100072 }, -- Keywright's Gallery
[1995] = { type = ZT_INDOOR, d1m = 0.0038598567 }, -- Balfiera Ruins
[2036] = { type = ZT_INDOOR, d1m = 0.0036817104 }, -- Balfiera Ruins
[2037] = { type = ZT_INDOOR, d1m = 0.0035823956 }, -- Balfiera Ruins
[2039] = { type = ZT_INDOOR, d1m = 0.0036014839 }, -- Balfiera Ruins

-- ===============================================================================
[1484] = { type = ZT_ZONE, d1m = 0.0003850887 }, -- Murkmire
[1560] = { type = ZT_SUBZONE, d1m = 0.001440769 }, -- Lilmoth
[1561] = { type = ZT_SUBZONE, d1m = 0.0036284458 }, -- Bright-Throat Village
[1562] = { type = ZT_SUBZONE, d1m = 0.0023736927 }, -- Dead-Water Village
[1563] = { type = ZT_SUBZONE, d1m = 0.0024724285 }, -- Root-Whisper Village - empty
[1301] = { d1m = 0.0090886857 }, -- Wither-Vault
[1507] = { d1m = 0.0047499389 }, -- Teeth Of Sithis
[1508] = { d1m = 0.0037962577 }, -- Teeth Of Sithis
[1522] = { d1m = 0.0042757264 }, -- Teeth Of Sithis
[1506] = { d1m = 0.0017332697 }, -- Tsofeer Cavern
[1509] = { d1m = 0.0019088103 }, -- Blight Bog Sump
[1515] = { d1m = 0.0019061801 }, -- Tomb of Many Spears
[1565] = { d1m = 0.0051938544 }, -- Echoing Hollow Ruins
[1514] = { d1m = 0.0019959169 }, -- Swallowed Grove
[1541] = { d1m = 0.0079908669 }, -- The Dreaming Nest
[1542] = { d1m = 0.0022084333 }, -- The Mists - Hunting Grounds
[1543] = { d1m = 0.0022817009 }, -- The Mists - The Vilage
[1544] = { d1m = 0.0046035598 }, -- The Mists - Hist Tree
[1539] = { d1m = 0.0019897387 }, -- Ixtaxh Xanmeer
[1557] = { d1m = 0.0030610784 }, -- Xul-Thuxis
[1558] = { d1m = 0.0033709232 }, -- Xul-Thuxis
[1559] = { d1m = 0.0035869328 }, -- Xul-Thuxis
[1526] = { d1m = 0.0021953741 }, -- Vakka-Bok Xanmeer
[1527] = { d1m = 0.0021085086 }, -- Vakka-Bok Xanmeer
[1528] = { d1m = 0.0036088005 }, -- Vakka-Bok Xanmeer
[1529] = { d1m = 0.0027453722 }, -- Vakka-Bok Xanmeer
[1530] = { d1m = 0.0039052133 }, -- Vakka-Bok Xanmeer
[1531] = { d1m = 0.0045260567 }, -- Vakka-Bok Xanmeer
[1532] = { d1m = 0.0059545413 }, -- Vakka-Bok Xanmeer
[1534] = { d1m = 0.0038140411 }, -- Vakka-Bok Xanmeer
[1520] = { d1m = 0.0017708621 }, -- Vakka-Bok Xanmeer - Deep-Root
[1540] = { d1m = 0.0030432655 }, -- Remnant of Argon
[1564] = { d1m = 0.0059442902 }, -- Singing Grotto

-- ===============================================================================
[1654] = { type = ZT_ZONE, d1m = 0.0002713487 }, -- Southern Elsweyr
[1675] = { type = ZT_SUBZONE, d1m = 0.0013743243 }, -- Senchal
[1684] = { d1m = 0.0017992368 }, -- Tideholm
[1683] = { d1m = 0.0064651117 }, -- Tidehoml Ruin
[1685] = { d1m = 0.0062894189 }, -- Tidehoml Ruin
[1686] = { d1m = 0.0060461363 }, -- Tidehoml Ruin
[1714] = { d1m = 0.0059072651 }, -- Tidehoml Ruin
[1682] = { d1m = 0.0036991155 }, -- Dragonguard Sanctum
[1676] = { d1m = 0.0020345967 }, -- Moonlit Cove
[1739] = { d1m = 0.001922072 }, -- Moonlit Cove
[1740] = { d1m = 0.0019054747 }, -- Moonlit Cove Tomb ok Kunzar-ri
[1741] = { d1m = 0.0021657332 }, -- Moonlit Cove
[1742] = { d1m = 0.001927035 }, -- Moonlit Cove
[1694] = { d1m = 0.0026324693 }, -- Forsaken Citadel
[1695] = { d1m = 0.0033799013 }, -- Forsaken Citadel
[1690] = { d1m = 0.0063771366 }, -- Senchal Palace
[1679] = { d1m = 0.0035977496 }, -- Senchal Outlaws Refuge
[1730] = { d1m = 0.0037713304 }, -- Black Kiergo Arena
[1731] = { d1m = 0.0038177785 }, -- Black Kiergo Arena
[1692] = { d1m = 0.0021968883 }, -- Passage of Dad'na Ghaten
[1674] = { d1m = 0.003929612 }, -- Zazaradi's Quarry and Mine
[1732] = { d1m = 0.0033448432 }, -- New Moon Fortress
[1733] = { d1m = 0.0015717811 }, -- New Moon Fortress
[1738] = { d1m = 0.0015745795 }, -- New Moon Fortress
[1743] = { d1m = 0.0017627842 }, -- New Moon Fortress
[1701] = { d1m = 0.0016818194 }, -- Halls of the Highmane
[1702] = { d1m = 0.0016645141 }, -- Path of Pride
[1735] = { d1m = 0.0033192281 }, -- Halls of the Highmane
[1711] = { d1m = 0.0017251456 }, -- Doomstone Keep
[1712] = { d1m = 0.0024222776 }, -- Doomstone Keep
[1713] = { d1m = 0.0022840929 }, -- The Spilled Sand
[1727] = { d1m = 0.0024024165 }, -- Dragonhold
[1728] = { d1m = 0.002381679 }, -- Dragonhold
[1729] = { d1m = 0.0023890887 }, -- Dragonhold
[1744] = { d1m = 0.0099330298 }, -- Dragonhold
[1745] = { d1m = 0.0045537353 }, -- Dragonhold - Flying island Ruins
[1746] = { d1m = 0.005274261 }, -- Dragonhold - Flying island Cave
[1687] = { d1m = 0.0019988695 }, -- Dragonhold - Flying island
[1689] = { d1m = 0.0023960784 }, -- Dragonhold
[1688] = { d1m = 0.0030878637 }, -- Jonelight Path

-- ===============================================================================
[258] = { type = ZT_ZONE, d1m = 0.0004876827 }, -- Khenarthi's Roost
[567] = { type = ZT_SUBZONE, d1m = 0.0017943787 }, -- Mistral
[328] = { d1m = 0.0032836857 }, -- Cat's Eye Quay
[329] = { d1m = 0.0030047774 }, -- Temple of the Mourning Springs
[605] = { d1m = 0.0053204693 }, -- Hazak's Lair
[743] = { d1m = 0.0050508661 }, -- The Mangroves
[744] = { d1m = 0.009145279 }, -- Shattered Shoals

-- ===============================================================================
[22] = { type = ZT_ZONE, d1m = 0.0003011848 }, -- Malabal Tor
[275] = { type = ZT_SUBZONE, d1m = 0.001313589 }, -- Velyn Harbor
[534] = { type = ZT_SUBZONE, d1m = 0.0018199402 }, -- Vulkwasten
[282] = { type = ZT_SUBZONE, d1m = 0.0020460781 }, -- Baandari Trading Post

-- ===============================================================================
[300] = { type = ZT_ZONE, d1m = 0.00033289 }, -- Greenshade
[529] = { type = ZT_SUBZONE, d1m = 0.0012729857 }, -- Woodhearth
[387] = { type = ZT_SUBZONE, d1m = 0.0021939696 }, -- Marbruk

-- ===============================================================================
[2212] = { type = ZT_ZONE, d1m = 0.0003024001 }, -- Galen and Y'ffelon
[2227] = { type = ZT_SUBZONE, d1m = 0.00112 }, -- Vastyr

-- ===============================================================================
[1006] = { type = ZT_ZONE, d1m = 0.0003903606 }, -- Gold Coast
[1074] = { type = ZT_SUBZONE, d1m = 0.0017236623 }, -- Anvil
[1009] = { type = ZT_SEWERS, d1m = 0.0053765306 }, -- Anvil Outlaws Refuge
[1064] = { type = ZT_SUBZONE, d1m = 0.0022356462 }, -- Kvatch
[1047] = { d1m = 0.0030275728 }, -- Anvil Castle
[1007] = { d1m = 0.0032402867 }, -- Hrota Cave
[1065] = { d1m = 0.0102547166 }, -- Hrota Cave
[1005] = { d1m = 0.0027937739 }, -- Garlas Agea
[1069] = { d1m = 0.0045544155 }, -- Tribune's Folly

-- ===============================================================================
[994] = { type = ZT_ZONE, d1m = 0.0003885012 }, -- Hew's Bane
[993] = { type = ZT_SUBZONE, d1m = 0.0010983781 }, -- Abah's Landing
[1025] = { d1m = 0.0019948311 }, -- Shark's Teeth Grotto
[1030] = { d1m = 0.0020001464 }, -- Shark's Teeth Grotto
[1003] = { d1m = 0.002324715 }, -- Bahraha's Gloom
[1026] = { d1m = 0.0023195135 }, -- Bahraha's Gloom
[1027] = { d1m = 0.0022929333 }, -- Bahraha's Gloom
[1013] = { d1m = 0.003719523 }, -- Thieves Den

-- ===============================================================================
[1349] = { type = ZT_ZONE, d1m = 0.0001762655 }, -- Summerset
[1431] = { type = ZT_SUBZONE, d1m = 0.0011896607 }, -- Shimmerene
[1430] = { type = ZT_SUBZONE, d1m = 0.0017004198 }, -- Alinor
[1455] = { type = ZT_SUBZONE, d1m = 0.0019638236 }, -- Lillandril
[1453] = { d1m = 0.0104330929 }, -- Alinor Outlaws Refuge
[1454] = { d1m = 0.010355667 }, -- Alinor Outlaws Refuge
[1438] = { type = ZT_DUNGEON, d1m = 0.0011481346 }, -- Sunhold
[1377] = { d1m = 0.0024114161 }, -- Tor-Hame-Khard
[1378] = { d1m = 0.0024244619 }, -- Tor-Hame-Khard
[1370] = { d1m = 0.0019172003 }, -- Archon's Grove
[1469] = { d1m = 0.0011343741 }, -- Wasten Coraldale
[1366] = { d1m = 0.0019530203 }, -- King's Haven Pass
[1367] = { d1m = 0.0025392356 }, -- King's Haven Pass - Coral-Splitter Caves
[1372] = { d1m = 0.0025995979 }, -- Eton Nir Grotto
[1373] = { d1m = 0.0096958727 }, -- Eton Nir Grotto
[1482] = { d1m = 0.0019379091 }, -- Shimmerene Waterworks
[1459] = { d1m = 0.0055140166 }, -- Monastery Of Serene Harmony
[1460] = { d1m = 0.0054634262 }, -- Monastery Of Serene Harmony
[1461] = { d1m = 0.0032014044 }, -- Monastery Of Serene Harmony - Undercroft
[1440] = { d1m = 0.0074112346 }, -- Red Temple Catacombs
[1441] = { d1m = 0.0028747635 }, -- Red Temple Catacombs
[1423] = { d1m = 0.0039303166 }, -- Cey-Tarn Keep
[1424] = { d1m = 0.0039613918 }, -- The Gorge - Cey-Tarn Keep
[1463] = { d1m = 0.004059654 }, -- The Gorge - The Vaults of Heinarwe
[1464] = { d1m = 0.0118232511 }, -- The Vaults of Heinarwe
[1465] = { d1m = 0.0118173654 }, -- The Vaults of Heinarwe
[1420] = { d1m = 0.0028738843 }, -- The Vaults of Heinarwe
[1421] = { d1m = 0.0059824545 }, -- The Vaults of Heinarwe
[1422] = { d1m = 0.0118999609 }, -- The Vaults of Heinarwe - Altar Room
[1466] = { d1m = 0.0072507213 }, -- Ebon Sanctum
[1467] = { d1m = 0.0072663442 }, -- Ebon Sanctum
[1404] = { d1m = 0.0019547266 }, -- Ebon Sanctum
[1380] = { d1m = 0.0018283526 }, -- Rellenthil Sinkhole
[1381] = { d1m = 0.0039312739 }, -- Illumination Academy Stacks
[1382] = { d1m = 0.0039808262 }, -- Illumination Academy Stacks
[1383] = { d1m = 0.0039454054 }, -- Illumination Academy Stacks
[1406] = { d1m = 0.0040584137 }, -- Illumination Academy Stacks
[1477] = { d1m = 0.0023348315 }, -- Corgrad Wastes
[1478] = { d1m = 0.0023117675 }, -- Corgrad Wastes
[1479] = { d1m = 0.0023160686 }, -- Corgrad Wastes
[1397] = { d1m = 0.0009246035 }, -- Karnwasten
[2110] = { d1m = 0.0015932437 }, -- Coral Aerie - Brackish Cove
[2185] = { d1m = 0.0040489178 }, -- Coral Aerie - Tide Hollow
-- TODO More Coral Aerie
[1409] = { d1m = 0.0023802134 }, -- Sea Keep
[1410] = { d1m = 0.002426 }, -- Sea Keep
[1496] = { d1m = 0.0023906563 }, -- Sea Keep
[1390] = { d1m = 0.0037419007 }, -- Saltbreeze Cave
[1500] = { d1m = 0.0038909181 }, -- Saltbreeze Cave
[1398] = { d1m = 0.0030930808 }, -- Direnni Acropolis
[1399] = { d1m = 0.0031894865 }, -- Direnni Acropolis
[1516] = { d1m = 0.0031325103 }, -- Direnni Acropolis
[1401] = { d1m = 0.0021647598 }, -- Direnni Acropolis
[1402] = { d1m = 0.002075503 }, -- Direnni Acropolis
[1498] = { d1m = 0.0022920914 }, -- Direnni Acropolis
[1443] = { d1m = 0.0051175725 }, -- Eldbur Ruins
[1444] = { d1m = 0.0051386371 }, -- Eldbur Ruins
[1448] = { d1m = 0.003735808 }, -- Eldbur Ruins - Cainar's Mind Trap
[1449] = { d1m = 0.003739134 }, -- Eldbur Ruins - Miriya's Mind Trap
[1450] = { d1m = 0.0037083823 }, -- Eldbur Ruins - Oriandra's Mind Trap
[1502] = { d1m = 0.0012447086 }, -- Cloudrest
[1445] = { d1m = 0.0088180945 }, -- Alinor Royal Palace
[1411] = { d1m = 0.004863975 }, -- College of Sapiarchs Labyrinth
[1412] = { d1m = 0.0072657423 }, -- College of Sapiarchs
[1480] = { d1m = 0.0046907407 }, -- College of Sapiarchs Labyrinth
[1403] = { d1m = 0.0018595971 }, -- Evergloam
[1405] = { d1m = 0.002936206 }, -- Cathedral of Webs
[1413] = { d1m = 0.002599655 }, -- Crystal Tower
[1414] = { d1m = 0.0048529866 }, -- Crystal Tower
[1415] = { d1m = 0.0052124445 }, -- Crystal Tower
[1416] = { d1m = 0.0039977538 }, -- Crystal Tower
[1417] = { d1m = 0.0066735234 }, -- Crystal Tower
[1418] = { d1m = 0.0104292323 }, -- Crystal Tower
[1419] = { d1m = 0.0075964756 }, -- Crystal Tower
[1486] = { d1m = 0.0065384591 }, -- Crystal Tower
[1487] = { d1m = 0.0048127435 }, -- Crystal Tower
[1491] = { d1m = 0.0054035194 }, -- Crystal Tower
[1495] = { d1m = 0.0041026405 }, -- Crystal Tower

-- ===============================================================================
[255] = { type = ZT_ZONE, d1m = 0.0002321149 }, -- Coldharbour
[422] = { type = ZT_SUBZONE, d1m = 0.0019871879 }, -- The Hollow City
[565] = { type = ZT_CAVE, d1m = 0.003700362 }, -- Tower of Lies - Liars Passage
[741] = { type = ZT_RUIN, d1m = 0.0074329711 }, -- Library of Dusk
[350] = { type = ZT_RUIN, d1m = 0.0039654534 }, -- Library of Dusk
[354] = { type = ZT_RUIN, d1m = 0.0022173017 }, -- Lightless Oubliette
[355] = { type = ZT_RUIN, d1m = 0.0022615527 }, -- Lightless Oubliette
[368] = { type = ZT_RUIN, d1m = 0.0018019564 }, -- Lightless Cell
[351] = { type = ZT_RUIN, d1m = 0.0031791224 }, -- Haj Uxith
[358] = { type = ZT_POCKET, d1m = 0.0018888335 }, -- The Manor of Revelry
[751] = { type = ZT_POCKET, d1m = 0.0099568385 }, -- The Manor of Revelry
[752] = { type = ZT_POCKET, d1m = 0.0103072703 }, -- The Manor of Revelry
[753] = { type = ZT_POCKET, d1m = 0.0102595532 }, -- The Manor of Revelry
[754] = { type = ZT_POCKET, d1m = 0.010037896 }, -- The Manor of Revelry
[755] = { type = ZT_POCKET, d1m = 0.0176000581 }, -- The Manor of Revelry
[787] = { type = ZT_POCKET, d1m = 0.0045042073 }, -- The Manor of Revelry Cave
[742] = { type = ZT_CAVE, d1m = 0.0073590345 }, -- The Lost Fleet - Coral Tower Tunnel
[738] = { type = ZT_CAVE, d1m = 0.0088415739 }, -- Holding Cells
[739] = { type = ZT_CELLAR, d1m = 0.0083318269 }, -- Thane's Lair
[371] = { type = ZT_CAVE, d1m = 0.001187542 }, -- The Black Forge
[372] = { type = ZT_CAVE, d1m = 0.0011735667 }, -- The Black Forge - Fabrication Chamber
[373] = { type = ZT_CAVE, d1m = 0.0011951698 }, -- The Black Forge - Boiler
[585] = { type = ZT_CAVE, d1m = 0.0014137048 }, -- The Great Shackle - Bridge
[586] = { type = ZT_CAVE, d1m = 0.0013003281 }, -- The Great Shackle
[587] = { type = ZT_CAVE, d1m = 0.0050235075 }, -- The Mooring
[353] = { type = ZT_RUIN, d1m = 0.0025648143 }, -- The Vile Laboratory
[356] = { type = ZT_RUIN, d1m = 0.0028100125 }, -- Grunda's Gatehouse
[357] = { type = ZT_RUIN, d1m = 0.0028878335 }, -- Grunda's Gatehouse
[740] = { type = ZT_RUIN, d1m = 0.0074695 }, -- Reaver Citadel Pyramid
[361] = { type = ZT_POCKET, d1m = 0.0024197419 }, -- The Endless Stair
[261] = { type = ZT_DELVE, d1m = 0.0023386714 }, -- The Grotto of Depravity
[322] = { type = ZT_DELVE, d1m = 0.0029316934 }, -- Mal Sorra's Tomb
[266] = { type = ZT_DELVE, d1m = 0.0034967929 }, -- Aba-Loria
[263] = { type = ZT_DELVE, d1m = 0.0029437384 }, -- The Wailing Maw
[352] = { type = ZT_DELVE, d1m = 0.0040001992 }, -- The Vault of Haman Forgefire
[593] = { type = ZT_DELVE, d1m = 0.0028908699 }, -- The Cave of Trophies
[339] = { type = ZT_DUNGEON, d1m = 0.0008478392 }, -- Village of the Lost

-- ===============================================================================
[2275] = { type = ZT_ZONE, d1m = 0.0002437765 }, -- Apocrypha
[2384] = { type = ZT_SUBZONE, d1m = 0.0038110488 }, -- Cipher's Midden
[2391] = { type = ZT_CAVE, d1m = 0.002476771 }, -- Central Orphic Tunnels

[2308] = { d1m = 0.0054007683 }, -- The Tranquil Catalog
[2309] = { d1m = 0.005336233 }, -- Shrine of Hyrma Mora
[2310] = { d1m = 0.0059516846 }, -- Shrine of Herma-Mora
[2311] = { d1m = 0.0064883312 }, -- Shrine of Hermorah
[2312] = { d1m = 0.0065249844 }, -- Catalog Boss Location
[2313] = { d1m = 0.0216147188 }, -- Pool of Inquiry
[2355] = { d1m = 0.0017384532 }, -- Fathoms Drift
[2389] = { d1m = 0.0017487536 }, -- Fathoms Drift
[2349] = { d1m = 0.0016579471 }, -- Apogee of the Tormenting Eye
[2393] = { d1m = 0.0047393161 }, -- Apogee of the Tormenting Eye - Ritual Site
[2334] = { d1m = 0.0021541181 }, -- Quires Wind
[2317] = { d1m = 0.0015904261 }, -- The Disquiet Study
[2350] = { d1m = 0.0024083667 }, -- Underweave Courtyard
[2351] = { d1m = 0.0051310903 }, -- Underweave Heart
[2352] = { d1m = 0.0025393624 }, -- Underweave Nullifactory
[2404] = { d1m = 0.0106759397 }, -- Martina's Sanctum
[2344] = { d1m = 0.002147904 }, -- The Forbidden Exhibit
[2367] = { d1m = 0.0018940096 }, -- Rectory Network
[2318] = { d1m = 0.0071428571 }, -- The Infinite Panopticon
[2319] = { d1m = 0.0070048628 }, -- The Infinite Panopticon
[2320] = { d1m = 0.0055525169 }, -- The Infinite Panopticon
[2321] = { d1m = 0.0074374381 }, -- The Infinite Panopticon
[2322] = { d1m = 0.002962805 }, -- The Infinite Panopticon
[2323] = { d1m = 0.0076347144 }, -- The Infinite Panopticon
[2324] = { d1m = 0.0052536234 }, -- The Infinite Panopticon
[2326] = { d1m = 0.0044599161 }, -- The Infinite Panopticon
[2335] = { d1m = 0.0044753614 }, -- The Infinite Panopticon
[2368] = { d1m = 0.0024571187 }, -- The Infinite Panopticon
[2369] = { d1m = 0.0029091255 }, -- The Infinite Panopticon
[2370] = { d1m = 0.0052321791 }, -- The Infinite Panopticon
[2398] = { d1m = 0.0072153749 }, -- The Infinite Panopticon
[2329] = { d1m = 0.0037400077 }, -- The Mythos
[2358] = { d1m = 0.0043816697 }, -- The Mythos Vaults
[2359] = { d1m = 0.001591558 }, -- The Mythos
[2371] = { d1m = 0.0045734917 }, -- The Mythos Vault
[2375] = { d1m = 0.0016207254 }, -- The Mythos
[2376] = { d1m = 0.005081471 }, -- The Mythos
[2356] = { d1m = 0.002183616 }, -- The Sidereal Cloisters
[2405] = { d1m = 0.0043666952 }, -- The Sidereal Cloisters
[2346] = { d1m = 0.0031745157 }, -- Obscured Forum
[2392] = { d1m = 0.0037457381 }, -- Northern Orphic Tunnels
[2336] = { d1m = 0.003474782 }, -- Cenotaph Fundament
[2337] = { d1m = 0.0026340269 }, -- Courtyard of Communion
[2338] = { d1m = 0.0137340332 }, -- Cenotaph Rise
[2339] = { d1m = 0.0035517417 }, -- Cathedral of Hermaeus Mora
[2340] = { d1m = 0.0015157883 }, -- The Crux
[2566] = { d1m = 0.0020130509 }, -- Infinite Archive
[2407] = { d1m = 0.0028908178 }, -- Infinite Archive - Antechamber
[2411] = { d1m = 0.0103364993 }, -- Infinite Archive
[2417] = { d1m = 0.0012677309 }, -- Infinite Archive - Wings 6
[2418] = { d1m = 0.0022355863 }, -- Infinite Archive - Boss
[2410] = { d1m = 0.0048305877 }, -- Infinite Archive - Wings 2
[2425] = { d1m = 0.0100154217 }, -- Infinite Archive - Destozuno's Library
[2415] = { d1m = 0.0019421334 }, -- Infinite Archive - Wings 4
[2416] = { d1m = 0.002291892 }, -- Infinite Archive - Wings 5
[2424] = { d1m = 0.0101507626 }, -- Infinite Archive - Theater of War
[2408] = { d1m = 0.0027402798 }, -- Infinite Archive - Wings 1
[2422] = { d1m = 0.0057604246 }, -- Infinite Archive - Filer's Wing
[2419] = { d1m = 0.0051941185 }, -- Infinite Archive - Tho'at Replicanum
[2420] = { d1m = 0.0061570182 }, -- Infinite Archive - Treacherous Crossing
[2421] = { d1m = 0.0033597915 }, -- Infinite Archive - Heafal's Butchery
[2414] = { d1m = 0.0014414808 }, -- Infinite Archive - Wings 3
[2423] = { d1m = 0.0065517557 }, -- Infinite Archive - Echoing Den


-- ===============================================================================
[1429] = { type = ZT_ZONE, d1m = 0.0006685503 }, -- Artaeum
[1503] = { type = ZT_RUIN, d1m = 0.0056992395 }, -- College of Psijics Ruins
[1493] = { type = ZT_RUIN, d1m = 0.0057857578 }, -- College of Psijics Ruins
[1492] = { d1m = 0.0057192767 }, -- College of Psijics Ruins
[1388] = { d1m = 0.0052665588 }, -- Psijic Relic Vaults
[1472] = { d1m = 0.0052691109 }, -- Psijic Relic Vaults
[1389] = { d1m = 0.0040166394 }, -- K'Tora's Mindscape
[1470] = { type = ZT_CAVE, d1m = 0.0122416255 }, -- The Dreaming Cave
[1476] = { type = ZT_INDOOR, d1m = 0.0055373652 }, -- Ceporah Tower
[1488] = { type = ZT_INDOOR, d1m = 0.0092728526 }, -- Ceporah Tower - Valsirenn's Study
[1489] = { type = ZT_INDOOR, d1m = 0.0090905429 }, -- Ceporah Tower - Ritemaster Study
[1490] = { type = ZT_INDOOR, d1m = 0.0091401959 }, -- Ceporah Tower - Sotha Sil's Study
[1393] = { d1m = 0.0022843587 }, -- The Spiral Skein
[1394] = { d1m = 0.0091131521 }, -- The Spiral Skein
[1395] = { d1m = 0.0048335593 }, -- The Spiral Skein
[1396] = { d1m = 0.0046141419 }, -- The Spiral Skein
[1497] = { d1m = 0.0034553138 }, -- The Spiral Skein
[1499] = { d1m = 0.0091137589 }, -- The Spiral Skein
[1471] = { type = ZT_DELVE, d1m = 0.0031010005 }, -- Traitor's Vault
[1473] = { type = ZT_DELVE, d1m = 0.0030088954 }, -- Traitor's Vault
[1474] = { type = ZT_DELVE, d1m = 0.0030954662 }, -- Traitor's Vault
[1475] = { type = ZT_DELVE, d1m = 0.0030378679 }, -- Traitor's Vault

-- ===============================================================================
[2035] = { type = ZT_SUBZONE, d1m = 0.00169538 }, -- Fargrave City District
[2082] = { type = ZT_SUBZONE, d1m = 0.00132534 }, -- The Shambles
[2099] = { type = ZT_SEWERS, d1m = 0.0043935064 }, -- Fargrave Outlaws Refuge
[2100] = { type = ZT_SEWERS, d1m = 0.004417668 }, -- Fargrave Outlaws Refuge
[2136] = { type = ZT_INDOOR, d1m = 0.0065733515 }, -- The Bazaar

-- ===============================================================================
[2021] = { type = ZT_ZONE, d1m = 0.0002991617 }, -- The Deadlands

-- ===============================================================================
[2114] = { type = ZT_ZONE, d1m = 0.000202333 }, -- High Isle and Amenos
[2163] = { type = ZT_SUBZONE, d1m = 0.001435772 }, -- Gonfalon Bay
[2214] = { type = ZT_SUBZONE, d1m = 0.0022311999 }, -- Amenos Station
[2213] = { d1m = 0.0037654485 }, -- Stonelore Grove
[2130] = { d1m = 0.0019922983 }, -- Breakwater Cave
[2156] = { d1m = 0.0018793594 }, -- The Firepot
[2133] = { d1m = 0.0028320556 }, -- Death's Valor Keep
[2134] = { d1m = 0.0030277071 }, -- Death's Valor Keep Catacombs
[2131] = { d1m = 0.0014294369 }, -- Shipwreck Shoals
[2132] = { d1m = 0.0037698271 }, -- Shipwreck Shoals - Hadolid Warrens
[2153] = { d1m = 0.0023280267 }, -- Coral Cliffs
[2154] = { d1m = 0.0040737656 }, -- Coral Cliffs - Cave
[2138] = { d1m = 0.0015078225 }, -- Whalefall
[2221] = { d1m = 0.0027774766 }, -- Mysterious Cave
[2219] = { d1m = 0.0066989641 }, -- Castle Navire Knight's Wing
[2223] = { d1m = 0.0043403305 }, -- Castle Navire South Courtyard
[2174] = { d1m = 0.002049985 }, -- Castle Navire Chapel
[2161] = { d1m = 0.0042543335 }, -- The Undergrove
[2159] = { d1m = 0.0017171426 }, -- Garick's Rest
[2215] = { d1m = 0.0026790279 }, -- Garick's Rest
[2216] = { d1m = 0.0026929806 }, -- Garick's Rest
[2217] = { d1m = 0.0017994482 }, -- Garick's Rest
[2164] = { d1m = 0.0012218497 }, -- Dreadsail Reef
[2146] = { d1m = 0.002179686 }, -- Abhain Chapel Crypts
[2171] = { d1m = 0.0012151841 }, -- Spire of the Crimson Coin
[2205] = { d1m = 0.0121910462 }, -- Spire of the Crimson Coin - Statuary Hall
[2200] = { d1m = 0.0039246455 }, -- Spire of the Crimson Coin - Prison Warrens
[2204] = { d1m = 0.0095853875 }, -- Spire of the Crimson Coin - Blacksmith Shop
[2196] = { d1m = 0.0075014559 }, -- Spire of the Crimson Coin - First Level of the Spire
[2197] = { d1m = 0.0075570331 }, -- Spire of the Crimson Coin - Second Level of the Spire
[2198] = { d1m = 0.0066181464 }, -- Spire of the Crimson Coin - Spire Lower Sanctum
[2201] = { d1m = 0.0065306767 }, -- Spire of the Crimson Coin - Lower Sanctum Stairway
[2202] = { d1m = 0.0064345194 }, -- Spire of the Crimson Coin - Upper Sanctum Stairway
[2203] = { d1m = 0.0064711785 }, -- Spire of the Crimson Coin - Spire Upper Sanctum
[2162] = { d1m = 0.0026235579 }, -- Tarnished Grotto
[2172] = { d1m = 0.0043272181 }, -- Castle Navire Courtyard
[2173] = { d1m = 0.0035072543 }, -- Lower Castle Navire
[2211] = { d1m = 0.0021063456 }, -- Ghost Haven Bay
[2199] = { d1m = 0.0018068313 }, -- Ghost Haven Bay Cavern
[2160] = { d1m = 0.002073948 }, -- Brokerock Mine
[2175] = { d1m = 0.0064978021 }, -- Old Coin Fort
[2176] = { d1m = 0.0027926837 }, -- Coin Fort Docks
[2177] = { d1m = 0.002923843 }, -- Old Coin Fort
[2167] = { d1m = 0.0022629256 }, -- Mistmouth Cave
[2168] = { d1m = 0.0021774682 }, -- Navire Dungeons
[2195] = { d1m = 0.0024721096 }, -- All Flags Islet
[2193] = { d1m = 0.0043265445 }, -- All Flags Islet - All Flags Castle
[2194] = { d1m = 0.0083586882 }, -- All Flags Islet - Memorial Hall
[2178] = { d1m = 0.0033530542 }, -- Systres Sisters Vault
[2206] = { d1m = 0.0012688415 }, -- Earthen Root Enclave
[2229] = { d1m = 0.0015927534 }, -- Graven Deep

-- ===============================================================================
[1313] = { type = ZT_ZONE, d1m = 0.0003883737 }, -- Clockwork City
[1348] = { type = ZT_SUBZONE, d1m = 0.0010899191 }, -- Brass Fortress
[1362] = { type = ZT_INDOOR, d1m = 0.0019707225 }, -- Mechanical Fundament
[1335] = { type = ZT_INDOOR, d1m = 0.0020565569 }, -- Mechanical Fundament
[1385] = { type = ZT_INDOOR, d1m = 0.0059019841 }, -- Clockwork Basilica

-- ===============================================================================
[2427] = { type = ZT_NONE, d1m = 0.0001857625 }, -- West Weald
[2514] = { type = ZT_NONE, d1m = 0.0012258665 }, -- Skingrad
[2501] = { type = ZT_NONE, d1m = 0.0026774126 }, -- Skingrad Outlaws Refuge
[2604] = { type = ZT_NONE, d1m = 0.0035726306 }, -- Vashabar
[2592] = { type = ZT_NONE, d1m = 0.0014973795 }, -- Ontus
[2519] = { type = ZT_NONE, d1m = 0.0064299461 }, -- Sunnamere
[2440] = { type = ZT_NONE, d1m = 0.0063950629 }, -- Rustwall Catacombs
[2550] = { type = ZT_NONE, d1m = 0.0028729929 }, -- Rustwall Catacombs
[2568] = { type = ZT_NONE, d1m = 0.0094679577 }, -- Weatherleah Manor
[2573] = { type = ZT_NONE, d1m = 0.031431509 }, -- Weatherleah Basement
[2471] = { type = ZT_NONE, d1m = 0.0037394524 }, -- Weatherleah Cavern
[2444] = { type = ZT_NONE, d1m = 0.0020764399 }, -- Elenglynn
[2445] = { type = ZT_NONE, d1m = 0.0015349056 }, -- Wendir
[2458] = { type = ZT_NONE, d1m = 0.0032057342 }, -- Valente Winery
[2460] = { type = ZT_NONE, d1m = 0.0036616977 }, -- Valente Winery Shipping Cavern
[2516] = { type = ZT_NONE, d1m = 0.0048840825 }, -- Zeggar's Blind
[2454] = { type = ZT_NONE, d1m = 0.0025173216 }, -- Essondul
[2506] = { type = ZT_NONE, d1m = 0.0071548469 }, -- Wilderhall
[2507] = { type = ZT_NONE, d1m = 0.0048583816 }, -- Cualorn
[2472] = { type = ZT_NONE, d1m = 0.005479524 }, -- Feldagard Keep
[2473] = { type = ZT_NONE, d1m = 0.0063481041 }, -- Feldagard Keep Barracks
[2474] = { type = ZT_NONE, d1m = 0.006834363 }, -- Feldagard Keep Barracks
[2475] = { type = ZT_NONE, d1m = 0.0054867919 }, -- Mirrormoor
[2486] = { type = ZT_NONE, d1m = 0.0036297983 }, -- Sutch Mine
[2508] = { type = ZT_NONE, d1m = 0.0023946823 }, -- Hoperoot
[2588] = { type = ZT_NONE, d1m = 0.0023917222 }, -- Hoperoot
[2593] = { type = ZT_NONE, d1m = 0.002331068 }, -- Hoperoot
[2594] = { type = ZT_NONE, d1m = 0.0035433035 }, -- Hoperoot
[2589] = { type = ZT_NONE, d1m = 0.0035763706 }, -- Hoperoot
[2490] = { type = ZT_NONE, d1m = 0.0071417378 }, -- Outcast Inn Cellar
[2491] = { type = ZT_NONE, d1m = 0.0067010282 }, -- Ithelia's Shrine
[2492] = { type = ZT_NONE, d1m = 0.0022202805 }, -- Ithelia's Shrine
[2493] = { type = ZT_NONE, d1m = 0.0022195611 }, -- Ithelia's Shrine
[2468] = { type = ZT_NONE, d1m = 0.0019518791 }, -- Niryastare
[2505] = { type = ZT_NONE, d1m = 0.00475731 }, -- Hastrel Hollow Shrine
[2503] = { type = ZT_NONE, d1m = 0.0086219789 }, -- Terthil's Well Cave
[2504] = { type = ZT_NONE, d1m = 0.0070424002 }, -- Fort Dirich Dungeons
[2500] = { type = ZT_NONE, d1m = 0.0020549539 }, -- Miscarcand
[2502] = { type = ZT_NONE, d1m = 0.0042711464 }, -- Miscarcand
[2509] = { type = ZT_NONE, d1m = 0.004741517 }, -- Fargrave Outer Ruins
[2558] = { type = ZT_NONE, d1m = 0.0029881389 }, -- Fargrave Inner Quarter
[2512] = { type = ZT_NONE, d1m = 0.0031861683 }, -- Fargrave Loom Quarter
[2605] = { type = ZT_NONE, d1m = 0.0073760964 }, -- Ithelia's Prison
[2513] = { type = ZT_NONE, d1m = 0.0042846957 }, -- Loom of the Untraveled Road
[2582] = { type = ZT_NONE, d1m = 0.0055787493 }, -- Caelum Cellars
[2585] = { type = ZT_NONE, d1m = 0.0057202573 }, -- Caelum Cellars Inner Vaults
[2590] = { type = ZT_NONE, d1m = 0.0056568936 }, -- Caelum Cellars Sewers
[2442] = { type = ZT_NONE, d1m = 0.0020313638 }, -- Varen's Watch
[2595] = { type = ZT_NONE, d1m = 0.0055759803 }, -- Varen's Watch
[2432] = { type = ZT_NONE, d1m = 0.0014366874 }, -- Fyrelight Cave
[2439] = { type = ZT_NONE, d1m = 0.0016864751 }, -- Nonungalo
[2459] = { type = ZT_NONE, d1m = 0.00143721 }, -- Fort Colovia
[2433] = { type = ZT_NONE, d1m = 0.0022994067 }, -- Legion's Rest
[2453] = { type = ZT_NONE, d1m = 0.0014692443 }, -- Haldain Lumber Camp
[2441] = { type = ZT_NONE, d1m = 0.0012948504 }, -- Silorn
[2456] = { type = ZT_NONE, d1m = 0.0015579194 }, -- Leftwheal Trading Post
[2552] = { type = ZT_NONE, d1m = 0.0008915378 }, -- Lucent Citadel

-- ===============================================================================
[2515] = { type = ZT_NONE, d1m = 0.0035152244 }, -- The Scholarium
[2525] = { type = ZT_NONE, d1m = 0.0023908911 }, -- The Scholarium Ruins
[2520] = { type = ZT_NONE, d1m = 0.0060463738 }, -- Wing of the Indrik

-- ===============================================================================
[737] = { d1m = 0.0078729547 }, -- The Harborage
[507] = { d1m = 0.002024753 }, -- Halls of Torment
[508] = { d1m = 0.00213936 }, -- Halls of Torment

[437] = { d1m = 0.0308413925 }, -- Vision of the Companions
[100] = { d1m = 0.0012037183 }, -- Foundry of Woe

[483] = { d1m = 0.0044093162 }, -- The Wailing Prison
[484] = { d1m = 0.0093752316 }, -- The Wailing Prison - The Bleeding Forge
[486] = { d1m = 0.0025333912 }, -- The Wailing Prison - The Towers of Eyes
[487] = { d1m = 0.004171014 }, -- The Wailing Prison- The Undercroft
[488] = { d1m = 0.0050705096 }, -- The Wailing Prison - The Prophet's Cell
[489] = { d1m = 0.0045750326 }, -- The Wailing Prison - The Anchor Mooring

[495] = { d1m = 0.0034759 }, -- Sancre Tor - Antechamber
[496] = { d1m = 0.0050262527 }, -- Sancre Tor - Crypt of Heroes
[497] = { d1m = 0.005334161 }, -- Sancre Tor - Inner Chamber
[498] = { d1m = 0.0053133478 }, --Sancre Tor - Inner Courtyard
[499] = { d1m = 0.0063568617 }, -- Sancre Tor - Reman Vault
[500] = { d1m = 0.0060668284 }, -- Sancre Tor - Dragonguard Tomb
[501] = { d1m = 0.0045995765 }, -- Sancre Tor - Vault Antechamber
[502] = { d1m = 0.0059140444 }, -- Sancre Tor - Vault of Kings

[516] = { d1m = 0.0019902342 }, -- Valley of Blades
[517] = { d1m = 0.0044704724 }, -- Valley of Blades - Ancestral Crypt


-- ===============================================================================
[16] = { d1m = 0.0001171357 }, -- Cyrodiil
[1661] = { d1m = 0.0039978861 }, -- Cheesemonger's Hollow
[573] = { d1m = 0.0013352976 }, -- Northern Morrowind Gate
[574] = { d1m = 0.001354273 }, -- Southern Morrowind Gate


[285] = { d1m = 0.0033204326 }, -- Breakneck Cave
[286] = { d1m = 0.0039011301 }, -- Haynote Cave
[287] = { d1m = 0.0054117807 }, -- Muck Valley Cavern
[288] = { d1m = 0.0045828676 }, -- Underpall Cave
[289] = { d1m = 0.0045267124 }, -- Red Ruby Cave
[290] = { d1m = 0.0039108927 }, -- Lipsand Tarn
[291] = { d1m = 0.003912211 }, -- Pothole Caverns
[293] = { d1m = 0.0058367974 }, -- Toadstool Hollow
[294] = { d1m = 0.0035712208 }, -- Toadstool Hollow
[299] = { d1m = 0.0037768501 }, -- Vahtacen
[340] = { d1m = 0.0090385283 }, -- Kingscrest Cavern

[466] = { d1m = 0.0051074989 }, -- Serpent Hollow Cave
[467] = { d1m = 0.0037269165 }, -- Nisin Cave
[468] = { d1m = 0.0040629666 }, -- Newt Cave
[469] = { d1m = 0.0034341934 }, -- Bloodmayne Cave
[470] = { d1m = 0.0042175581 }, -- Capstone Cave
[471] = { d1m = 0.0037834058 }, -- Quickwater Cave
[472] = { d1m = 0.0051644737 }, -- Quickwater Depths
[473] = { d1m = 0.0036799562 }, -- Echo Cave
[474] = { d1m = 0.0032681042 }, -- Cracked Wood Cave



-- ===============================================================================
[660] = { d1m = 0.0009137505 }, -- Imperial City
[785] = { d1m = 0.0003259916 }, -- Barathrum Centrata
[890] = { d1m = 0.000317002 }, -- Harena Hypogeum
[891] = { d1m = 0.0003255053 }, -- Antediluvian Vaults
[900] = { d1m = 0.0003248974 }, -- Lambent Passage
[901] = { d1m = 0.0003256086 }, -- Vile Drainage
[902] = { d1m = 0.0003233072 }, -- Wavering Veil
[903] = { d1m = 0.0003217392 }, -- Alessian Tombs
[905] = { d1m = 0.0003244409 }, -- Wavering Veil
[906] = { d1m = 0.0003217392 }, -- Alessian Tombs



[765] = { d1m = 0.0047850433 }, -- Imperial City Prison - Prison District
[767] = { d1m = 0.0029668411 }, -- Imperial City Prison - Imperial Prison
[768] = { d1m = 0.0038285472 }, -- Imperial City Prison - Imperial Subterrane
[769] = { d1m = 0.0038651263 }, -- Imperial Prison
[770] = { d1m = 0.0015998593 }, -- Imperial City Prison - Unnatural Caverns
[771] = { d1m = 0.0022397191 }, -- Imperial City Prison - Lost Sanctum

-- ===============================================================================
[1703] = { d1m = 0.0033406493 }, -- Wind Scour Temple
[1704] = { d1m = 0.0022920683 }, -- Storm Talon Temple
[1705] = { d1m = 0.0022958461 }, -- Dark Water Temple
[1706] = { d1m = 0.001899402 }, -- Valley of Blades
[1707] = { d1m = 0.0015731373 }, -- Vahlokzin's Domain
[1708] = { d1m = 0.0013897877 }, -- Vahlokzin's Lair
[1709] = { d1m = 0.002487503 }, -- Vahlokzin's Lair
[1710] = { d1m = 0.0046423993 }, -- Vahlokzin's Lair


-- ===============================================================================
-- Fighters guild
[241] = { d1m = 0.0056900887 }, -- Stonefang Cavern

[102] = { d1m = 0.0022533422 }, -- Mzeneldt
[103] = { d1m = 0.0017372258 }, -- The Earth Forge
[583] = { d1m = 0.0085430814 }, -- The Earth Forge - Pressure Room III
[104] = { d1m = 0.0050662253 }, -- Ragnthar

-- ===============================================================================

-- TODO: Need to sort 

















[1327] = { d1m = 0.003555925 }, -- Clockwork City Vaults
[1328] = { d1m = 0.0037832755 }, -- Clockwork City Vaults
[1329] = { d1m = 0.0017328584 }, -- Clockwork City Vaults

[2443] = { d1m = 0.0056979065 }, -- Sanctuary of Whispers






[415] = { d1m = 0.0018019178 }, -- Stirk



}

-- LuaFormatter on
