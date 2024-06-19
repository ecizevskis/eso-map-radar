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

-- ============================================================================== 
[30] = { type = ZT_ZONE, d1m = 0.0002428292 }, -- Alik'r Desert
[83] = { type = ZT_SUBZONE, d1m = 0.0011790012 }, -- Sentinel
[538] = { type = ZT_SUBZONE, d1m = 0.0019356809 }, -- Kozanset
[539] = { type = ZT_SUBZONE, d1m = 0.0018257869 }, -- Bergama
[246] = { type = ZT_DELVE, d1m = 0.0029204309 }, -- Santaki

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

-- ============================================================================== 
[125] = { type = ZT_ZONE, d1m = 0.0002438741 }, -- The Rift
[542] = { type = ZT_SUBZONE, d1m = 0.0017322909 }, -- Shor's Stone
[543] = { type = ZT_SUBZONE, d1m = 0.0013857898 }, -- Nimalten
[198] = { type = ZT_SUBZONE, d1m = 0.0017220367 }, -- Riften
[815] = { type = ZT_SEWERS, d1m = 0.0052393002 }, -- Riften Outlaws Refuge
[1784] = { type = ZT_SEWERS, d1m = 0.0037908691 }, -- Riften Ratway Lower
[1753] = { type = ZT_SEWERS, d1m = 0.0037930828 }, -- Riften Ratway
[103] = { type = ZT_POCKET, d1m = 0.0017372258 }, -- The Earth Forge
[583] = { type = ZT_POCKET, d1m = 0.0085430814 }, -- The Earth Forge - Pressure Room III
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

--  ============================================================================== 
[108] = { type = ZT_ZONE, d1m = 0.0016754935 }, -- Eyevea

--  ============================================================================== 
[7] = { type = ZT_ZONE, d1m = 0.0002737997 }, -- Stonefalls
[24] = { type = ZT_SUBZONE, d1m = 0.0013623396 }, -- Davon's Watch
[510] = { type = ZT_SUBZONE, d1m = 0.0016319819 }, -- Kragenmoor
[511] = { type = ZT_SUBZONE, d1m = 0.0012971857 }, -- Ebonheart

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
[126] = { type = ZT_CAVE, d1m = 0.0029097984 }, -- Deepcrag Den

--  ============================================================================== 
[61] = { type = ZT_ZONE, d1m = 0.0002429406 }, -- Eastmarch
[160] = { type = ZT_SUBZONE, d1m = 0.001828079 }, -- Windhelm
[578] = { type = ZT_SUBZONE, d1m = 0.0019801475 }, -- Fort Amol
[1781] = { type = ZT_INDOOR, d1m = 0.0083289884 }, -- Palace Of Kings
[1788] = { type = ZT_INDOOR, d1m = 0.0083866702 }, -- Palace Of Kings Dungeon
[1789] = { type = ZT_INDOOR, d1m = 0.0065098086 }, -- Palace of Kings Inner Chamber
[1794] = { type = ZT_INDOOR, d1m = 0.008328403 }, -- Palace Of Kings

[163] = { type = ZT_DELVE, d1m = 0.0037132925 }, -- The Chill Hollow
[166] = { type = ZT_DELVE, d1m = 0.004134479 }, -- The Frigid Grotto
[140] = { type = ZT_DUNGEON, d1m = 0.0019804589 }, -- Hall of the Dead

--  ============================================================================== 
[1887] = { type = ZT_ZONE, d1m = 0.0001989522 }, -- Blackwood
[2018] = { type = ZT_SUBZONE, d1m = 0.0024283691 }, -- Gideon
[1940] = { type = ZT_SUBZONE, d1m = 0.0020021955 }, -- Leyawiin
[2000] = { type = ZT_DUNGEON, d1m = 0.000729305 }, -- Atoll of Immolation

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
[88] = { type = ZT_MINE, d1m = 0.0037461546 }, -- Hozzin's Folly
[87] = { type = ZT_CAVE, d1m = 0.0031875867 }, -- Orkey's Hollow

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
[1279] = { type = ZT_DUNGEON, d1m = 0.0052680142 }, -- Kora Dur
[1277] = { type = ZT_DUNGEON, d1m = 0.0028944653 }, -- Caverns of Kogoruhn
[1278] = { type = ZT_DUNGEON, d1m = 0.003716386 }, -- Forgotten Depths
[1280] = { type = ZT_DUNGEON, d1m = 0.0070284756 }, -- Drinith Ancestral Tomb
[1300] = { type = ZT_DELVE, d1m = 0.0030112466 }, -- Pulk
[1161] = { type = ZT_DELVE, d1m = 0.0030347234 }, -- Pulk

-- ===============================================================================
[2274] = { type = ZT_ZONE, d1m = 0.0003372194 }, -- Telvanni Peninsula
[2343] = { type = ZT_SUBZONE, d1m = 0.0014023653 }, -- Necrom
[2386] = { type = ZT_SUBZONE, d1m = 0.0029882703 }, -- Ald Isra

-- ===============================================================================
[75] = { type = ZT_ZONE, d1m = 0.0007797666 }, -- Bal Foyen
[56] = { type = ZT_SUBZONE, d1m = 0.0032823159 }, -- Dhalmora

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


-- ===============================================================================
[1654] = { type = ZT_ZONE, d1m = 0.0002713487 }, -- Southern Elsweyr
[1675] = { type = ZT_SUBZONE, d1m = 0.0013743243 }, -- Senchal

-- ===============================================================================
[258] = { type = ZT_ZONE, d1m = 0.0004876827 }, -- Khenarthi's Roost
[567] = { type = ZT_SUBZONE, d1m = 0.0017943787 }, -- Mistral

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

-- ===============================================================================
[994] = { type = ZT_ZONE, d1m = 0.0003885012 }, -- Hew's Bane
[993] = { type = ZT_SUBZONE, d1m = 0.0010983781 }, -- Abah's Landing

-- ===============================================================================
[1349] = { type = ZT_ZONE, d1m = 0.0001762655 }, -- Summerset
[1431] = { type = ZT_SUBZONE, d1m = 0.0011896607 }, -- Shimmerene
[1430] = { type = ZT_SUBZONE, d1m = 0.0017004198 }, -- Alinor
[1455] = { type = ZT_SUBZONE, d1m = 0.0019638236 }, -- Lillandril
[1438] = { type = ZT_DUNGEON, d1m = 0.0011481346 }, -- Sunhold

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

-- ===============================================================================
[1429] = { type = ZT_ZONE, d1m = 0.0006685503 }, -- Artaeum
[1503] = { type = ZT_RUIN, d1m = 0.0056992395 }, -- College of Psijics Ruins
[1493] = { type = ZT_RUIN, d1m = 0.0057857578 }, -- College of Psijics Ruins
[1470] = { type = ZT_CAVE, d1m = 0.0122416255 }, -- The Dreaming Cave
[1476] = { type = ZT_INDOOR, d1m = 0.0055373652 }, -- Ceporah Tower
[1488] = { type = ZT_INDOOR, d1m = 0.0092728526 }, -- Ceporah Tower - Valsirenn's Study
[1489] = { type = ZT_INDOOR, d1m = 0.0090905429 }, -- Ceporah Tower - Ritemaster Study
[1490] = { type = ZT_INDOOR, d1m = 0.0091401959 }, -- Ceporah Tower - Sotha Sil's Study
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
-- TODO: Need to sort 





[710] = { d1m = 0.005086359 }, -- Yokudan Palace
[336] = { d1m = 0.0046970627 }, -- Salas En
[337] = { d1m = 0.0049273408 }, -- Impervious Vault
[226] = { d1m = 0.0029322787 }, -- Divad's Chagrin Mine
[553] = { d1m = 0.0046134077 }, -- Kulati Mines
[554] = { d1m = 0.0078632482 }, -- Kulati Mines
[50] = { d1m = 0.0051321651 }, -- Yokudan Palace
[51] = { d1m = 0.0017840399 }, -- Ash'abah Pass


[776] = { d1m = 0.0071759754 }, -- The Portal Chamber
[774] = { d1m = 0.0073212047 }, -- Shore Cave





--  ============================================================================== 
[0] = { type = ZT_ZONE, d1m = 11111111, zoneIndex = 0 }  -- xxxxxxx
}

-- LuaFormatter on
