## About distance calculation

All of the zones does not provide positions in any convertable units but in relative positions for whole map (all coords are relative position from 0 to 1 with decimal precision of 10).

They are somewhat close from viewer perspective but are a bit different for each zone if you aim for percission. As fart as I seen most addons just use some common coefficient for type of zone.

This addon is checking mapId instead of zoneId so it calibrates to any map texture you see (multiple zone levels/floors, multiple dungeon wings and so on). 

When showing distance labels in enabled then if they are yellow(ish) that means this map is not calibrated (for zone and subzone defaults are used and are inprecise but close, but all other types of maps just goes off the charts incorrect)
